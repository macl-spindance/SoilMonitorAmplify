//
//  CloudManager.swift
//  SoilMonitor
//
//  Created by Mac Lobdell on 7/22/21.
//

//tutorial on signup & sign in
//https://www.youtube.com/watch?v=wSHnmtnzbfs

//tutorial on to access to AWS IoT
//https://www.youtube.com/watch?v=dazrzrYVYRM

//Also reference this example
//https://github.com/awslabs/aws-sdk-ios-samples/tree/main/IoT-Sample/Swift/

//tutorial on connecting to AWS IoT
//https://medium.com/swlh/connect-an-ios-app-to-aws-iot-fc99d5a9562f
/*
import Foundation
import AWSIoT

struct Thing: Identifiable {
    var id: Int
    var model: String
    var device: String
}

class CloudManager: NSObject, ObservableObject {
    
    @Published var isConnected = false
    @Published var sensorValue: Int = 0
    @Published var myThing: Thing = Thing(id: 0, model: "unknown", device: "unknown")
    
    var myclientId: String?
    
    override init() {
        super.init()
        AWSIoTSetup()
    }


    func AWSIoTSetup()
    {
        
        // Initialize the Amazon Cognito credentials provider

        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId:IDENTITY_POOL_ID)

        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration

        // Initialising AWS IoT And IoT DataManager
        AWSIoT.register(with: configuration!, forKey: "kAWSIoT")  // Same configuration var as above  //todo: change to macro
        
        let iotEndPoint = AWSEndpoint(urlString: IOT_WS_ENDPOINT) // Access from AWS IoT Core --> Settings
        
        let iotDataConfiguration = AWSServiceConfiguration(region: .USEast1,     // Use AWS typedef .Region
                                                           endpoint: iotEndPoint,
                                                           credentialsProvider: credentialsProvider)  // credentials is the same var as created above
            
        AWSIoTDataManager.register(with: iotDataConfiguration!, forKey: "kDataManager") //todo: change to macro

      
        getAWSClientID{ [weak self] clientId, error in
            
            guard error == nil else{
                print("error getting client ID, \(String(describing: error))")
                return
            }
            guard let clientId = clientId else {
                print("client ID is nil")
                return
            }
            
            //referenced https://www.youtube.com/watch?v=wSHnmtnzbfs on how to call this asynchronously. using weak self above so it doesn't result in retained cycles
            DispatchQueue.main.async{
                self?.connectToAWSIoT(clientId: clientId)
            }
        }
        
    }

    func getAWSClientID(completion: @escaping (_ clientId: String?,_ error: Error? ) -> Void) {
        // Depending on your scope you may still have access to the original credentials var
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId: IDENTITY_POOL_ID)
        
        //You can retrieve a unique Amazon Cognito identifier (identity ID) for your end user immediately if you're allowing unauthenticated users
        //or after you've set the login tokens in the credentials provider if you're authenticating users:
        
        credentialsProvider.getIdentityId().continueWith(block: { (task:AWSTask<NSString>) -> Any? in
            if let error = task.error as NSError? {
                print("Failed to get client ID => \(error)")
                completion(nil, error)
                return nil  // Required by AWSTask closure
            }
            
            let clientId = task.result! as String
            print("Got client ID => \(clientId)")
            completion(clientId, nil)
            return nil // Required by AWSTask closure
        })
    }

    
    //the example unauthenticated role setup information I referenced setup a IAM policy that just allowed users to just get credentials
    //   and then later in the code it was able to attach an access policy that gave the user access to IoT resources. However since I don't have the
    //  policy attach part in my code, I had to change the unauthenticated user policy to allow access to IoT resources. 
    
    func connectToAWSIoT(clientId: String!) {
            
       guard let clientId = clientId else {return}  //return if the clientId is nil
        
        func mqttEventCallback(_ status: AWSIoTMQTTStatus ) {
            switch status {
            case .connecting: print("Connecting to AWS IoT")
            case .connected:
                print("Connected to AWS IoT")
                DispatchQueue.main.async{
                    self.isConnected = true
                }
                // Register subscriptions here
                // Publish a boot message if required
            case .connectionError: print("AWS IoT connection error")
            case .connectionRefused: print("AWS IoT connection refused")
            case .protocolError: print("AWS IoT protocol error")
            case .disconnected: print("AWS IoT disconnected")
                DispatchQueue.main.async{
                    self.isConnected = false
                }
            case .unknown: print("AWS IoT unknown state")
            default: print("Error - unknown MQTT state")
            }
        }
        
        // Ensure connection gets performed background thread (so as not to block the UI)
        DispatchQueue.global(qos: .background).async {

            print("Attempting to connect to IoT device gateway with ID = \(clientId)")
           
            //should this object not be created each time?
            let dataManager = AWSIoTDataManager(forKey: "kDataManager")  //todo: change to macro
            dataManager.connectUsingWebSocket(withClientId: clientId,
                                              cleanSession: true,
                                              statusCallback: mqttEventCallback)
            
            self.registerSubscriptions()
        }
    }

    func registerSubscriptions() {
            func messageReceived(payload: Data) {
                let payloadDictionary = jsonDataToDict(jsonData: payload)
                print("Message received: \(payloadDictionary)")
                
                // Handle message event here...
                
                guard let sensor = payloadDictionary["moisture"] else {
                    print("moisture not found")
                    return
                }
                
                print("sensor: \(sensor)")
               
                let device_name = payloadDictionary["device"]
               
                let model_name = payloadDictionary["model"]
                
                DispatchQueue.main.async{
                    self.sensorValue = sensor as! Int
                    self.myThing.device = device_name as! String
                    self.myThing.model = model_name as! String
                }
               
            }
            
            //Todo: the application should pair with one or more sensors and store their Thing Name
            // The application should only be allowed to access topics that coorespond to the Thing that they have paired with
        
            let topicArray = ["device/DEVKIT/lobdell01/sensor"] //, "$aws/things/lobdell01/shadow/+"]
            let dataManager = AWSIoTDataManager(forKey: "kDataManager") //todo: change to macro
            
            for topic in topicArray {
                print("Registering subscription to => \(topic)")
                dataManager.subscribe(toTopic: topic,
                                      qoS: .messageDeliveryAttemptedAtLeastOnce,  // Set according to use case
                                      messageCallback: messageReceived)
            }
    }

    func jsonDataToDict(jsonData: Data?) -> Dictionary <String, Any> {
            // Converts data to dictionary or nil if error
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: jsonData!, options: [])
                let convertedDict = jsonDict as! [String: Any]
                return convertedDict
            } catch {
                // Couldn't get JSON
                print(error.localizedDescription)
                return [:]
            }
    }
}
*/
