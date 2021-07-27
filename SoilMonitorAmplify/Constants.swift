/*
* Copyright 2010-2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

import Foundation
import AWSCore

//see example tutorial https://github.com/awslabs/aws-sdk-ios-samples/tree/main/IoT-Sample/Swift/

//let CertificateSigningRequestCommonName = "Soil Moisture Sensor Application"
//let CertificateSigningRequestCountryName = "USA"
//let CertificateSigningRequestOrganizationName = "SpinDance"
//let CertificateSigningRequestOrganizationalUnitName = "Lobdell Division"
//let PolicyName = "lobdell_soil_moisture_app_access"   //todo: this is referenced in the tutorial above, but not used in this project yet

let AwsRegion = AWSRegionType.Unknown  //todo: this is referenced in the tutorial above, but not used in this project yet
let IOT_ENDPOINT = "https://a2thrw602myi6-ats.iot.us-east-1.amazonaws.com" // make sure to include "https://" prefix
let IOT_WS_ENDPOINT = "wss://a2thrw602myi6-ats.iot.us-east-1.amazonaws.com/mqtt" //websocket

//let IDENTITY_POOL_ID = "us-east-1:4d0e7cb7-b69b-4fdd-be74-be10610ac9b8"

//Used as keys to look up a reference of each manager
let AWS_IOT_DATA_MANAGER_KEY = "kDataManager"
let AWS_IOT_MANAGER_KEY = "kAWSIoT"

