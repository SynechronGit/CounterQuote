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
    func uploadImage(url:String,image:UIImage) {
        let serverUrl = BASE_URL + url
        let imgData = UIImageJPEGRepresentation(image, 1.0)!

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData, withName: "AcordForm", fileName: "doc.jpeg", mimeType: "image/jpeg")
        }, to:serverUrl)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                NetworkManager.uploadRequest?.append(upload)
                upload.uploadProgress(closure: { (Progress) in
                    if ((Progress.fractionCompleted * 100) != 100) {
                        self.progressCallBack(progress: Float(Progress.fractionCompleted))
                    }
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    NetworkManager.uploadRequest = nil
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        self.successCallBack(response: JSON)
                    }
                    else
                    {
                        self.failureCallBack(error: "Json could not serialized")
                    }
                }
                
            case .failure(let encodingError):

                print(encodingError)
                self.failureCallBack(error: encodingError.localizedDescription)
            }
        }
    }
    
    func callPostMethod(paramaters:[String:Any], url:String)
    {
        let serverUrl = BASE_URL + url

        Alamofire.request(serverUrl, method: .post, parameters: paramaters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in

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
    
    func callGetMethod(url:String)
    {
        let serverUrl = BASE_URL + url
        Alamofire.request(serverUrl, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
}
