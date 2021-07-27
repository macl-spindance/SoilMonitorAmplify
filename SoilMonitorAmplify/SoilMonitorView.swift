//
//  SoilMonitorView.swift
//  Soil_Moisture_Monitor_App
//
//  Created by Mac Lobdell on 7/12/21.
//

import SwiftUI
/*
struct SoilMonitorView: View {
    @ObservedObject var bleManager = BLEManager()
    @ObservedObject var cloudManager = CloudManager()
    
    var body: some View {
        Text("Soil Monitor")
            .font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .center)
        
        Spacer()
        
        VStack (spacing: 10) {
             
            VStack (spacing: 10) {
                Text("BLE Device")
                    .font(.headline)
                List(bleManager.peripherals) { peripheral in
                    HStack {
                        Text(peripheral.name)
                        Spacer()
                        Text(String(peripheral.rssi))
                    }
                }.frame(height: 200)
                
               // Spacer()
                
                Text("Temp: \(bleManager.thermoValue)")   //this updates automatically
                    
                //Spacer()
                
                if bleManager.isConnected {
                    Text("BLE Sensor Connected")
                        .foregroundColor(.green)
                }
                else {
                    Text("BLE Sensor Disconnected")
                        .foregroundColor(.red)
                }
            }.frame(alignment: .top)
            
            Spacer()
            
            VStack (spacing: 10) {

                Text("AWS IoT Device")
                    .font(.headline)
                
                HStack {
                    Text(cloudManager.myThing.model)
                    Spacer()
                    Text(cloudManager.myThing.device)
                }
               // Spacer()
                
                Text("Moisture: \(cloudManager.sensorValue)")

              // Spacer()
                
                if cloudManager.isConnected {
                    Text("Cloud Connected")
                        .foregroundColor(.green)
                }
                else {
                    Text("Cloud Disconnected")
                        .foregroundColor(.red)
                }
            }.frame(alignment: .bottom)
        } //VStack
    } //body
    
}

struct SoilMonitorView_Previews: PreviewProvider {
    static var previews: some View {
        SoilMonitorView()
    }
}

*/
