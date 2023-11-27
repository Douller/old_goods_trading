//
//  AuthingLogin.swift
//  Runner
//
//  Created by red on 2023/3/20.
//

import Foundation
import Flutter
import Guard

class AuthingLoginPlugin {
    
   class func registerWithRegistry(messenger: FlutterBinaryMessenger){
        
        let channel = FlutterMethodChannel(name: "Authing", binaryMessenger: messenger)
       
        channel.setMethodCallHandler { (call:FlutterMethodCall, result: @escaping FlutterResult) in
            
            if(call.method == "login"){
                
                AuthFlow().start { code, message, userInfo in
                    
                    if code == 200 {
                        if(userInfo?.raw != nil){
                            let jsonData = try? JSONSerialization.data(withJSONObject: userInfo!.raw as Any)
                            if(jsonData != nil){
                                let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
                                print("ios---------- userJson = %@",jsonString ?? String())
                                result(jsonString)
                            }
                        }
                    }
                }
            }
        }
    }
}
