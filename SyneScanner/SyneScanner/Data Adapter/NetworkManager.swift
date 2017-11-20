//
//  NetworkManager.swift
//  SyneScanner
//
//  Created by Markel on 21/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import Alamofire

/**
 * Alamofire RESTful services manager
 */

class NetworkManager: NSObject {
    //MARK: - Properties
    static var uploadRequest: [Request]?
    
    //MARK: - Network Manager methods
    // Image uploading method
    func uploadImage(headers:[String:String], url:String, image:UIImage) {
        let baseUrl = getBaseUrl(index: (UserDefaults.standard.value(forKey: "env_preference") as? String)!)
        let serverUrl = baseUrl + url
        let imgData = UIImagePNGRepresentation(image)!

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData, withName: "PolicyDoc", fileName: "PolicyDoc.png", mimeType: "application/octed-stream")
        }, to:serverUrl)
        { (result) in
            switch result {
            case .success(let upload, _, _):
               //x upload.validate()

                NetworkManager.uploadRequest?.append(upload)
                upload.uploadProgress(closure: { (Progress) in
                    if ((Progress.fractionCompleted * 100) != 100) {
                        self.progressCallBack(progress: Float(Progress.fractionCompleted))
                    }
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    NetworkManager.uploadRequest = nil
                    let status = response.response?.statusCode
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                     if(!response.result.isSuccess) {
                        self.failureCallBack(error: "api failed")

                    }
                    else
                     {
                        self.successCallBack(response: ["":""])
                     }
                    

                }
                
            case .failure(let encodingError):

                print(encodingError)
                self.failureCallBack(error: encodingError.localizedDescription)
            }
        }
    }
    
    func callPostMethod(headers:[String:String], paramaters:[String:Any], url:String)
    {
        let baseUrl = getBaseUrl(index: (UserDefaults.standard.value(forKey: "env_preference") as? String)!)
        let serverUrl = baseUrl + url

        Alamofire.request(serverUrl, method: .post, parameters: paramaters, encoding: URLEncoding.httpBody).responseJSON { (response:DataResponse<Any>) in

            switch(response.result) {
            case .success(_):
                
                let status = response.response?.statusCode
                if status == 200
                {
                    if let data = response.result.value{
                        self.successCallBack(response: data)
                        
                    }
                    else{
                        self.failureCallBack(error: "Json could not serialized")
                        
                    }
                }
                else
                {
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                  self.failureCallBack(error: "api failed")
                }
                break
                
            case .failure(_):
                self.failureCallBack(error: (response.result.error?.localizedDescription)!)

                break
                
            }
        }
    }
    
    func callGetMethod(headers:[String:String], url:String)
    {
        let baseUrl = getBaseUrl(index: (UserDefaults.standard.value(forKey: "env_preference") as? String)!)
        let serverUrl = baseUrl + url
        Alamofire.request(serverUrl, method: .get, parameters: ["":""], encoding: URLEncoding.httpBody).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    self.successCallBack(response: data)

                }
                else{
                    self.failureCallBack(error: "Json could not serialized")
   
                }
                break
                
            case .failure(_):
                self.failureCallBack(error: (response.result.error?.localizedDescription)!)

                break
                
            }
        }
    }
    
    func callPostMethodReuturnStringResponse( url:String)
    {
        let baseUrl = getBaseUrl(index: (UserDefaults.standard.value(forKey: "env_preference") as? String)!)
        let serverUrl = baseUrl + url
        Alamofire.request(serverUrl, method: .post, parameters: ["":""])
            .responseString { response in
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print(data)
                        self.successCallBack(response: data)

                    }
                    
                case .failure(_):
                    self.failureCallBack(error: (response.result.error?.localizedDescription)!)
                }
        }
    }
    // Server success callback method
    func successCallBack(response:Any) {
        
    }
    
    // Server failure callback method
    func failureCallBack(error:String) {
        
    }
    
    // Server progress callback method
    func progressCallBack(progress:Float) {
        
    }
    
    //MARK: - Cancel Upload method
    class func cancelUploadRequest(index: Int)
    {
        uploadRequest?[index].cancel()
        uploadRequest?.remove(at: index)
    }
    
    func getBaseUrl(index: String) -> String {
        switch index {
        case "1":
            return DEV_BASE_URL
        case "2":
            return PROD_BASE_URL
        default:
            return DEV_BASE_URL
        }
    }
}
