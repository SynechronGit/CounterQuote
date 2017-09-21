//
//  NetworkManager.swift
//  SyneScanner
//
//  Created by Markel on 21/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {
    
    func uploadImage(url:String,image:UIImage)
    {
        let serverUrl = BASE_URL + url
        let imgData = UIImageJPEGRepresentation(image, 1.0)!

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData, withName: "photo_path", fileName: "doc.png", mimeType: "image/png")
        }, to:serverUrl)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    //self.removeImage("frame", fileExtension: "txt")
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
                //self.delegate?.showFailAlert()
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
                    print(response.result.value)
                    self.successCallBack(response: data)

                }
                else{
                    self.failureCallBack(error: "Json could not serialized")

                }
                break
                
            case .failure(_):
                print(response.result.error)
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
                    print(response.result.value)
                    self.successCallBack(response: data)

                }
                else{
                    self.failureCallBack(error: "Json could not serialized")
   
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.failureCallBack(error: (response.result.error?.localizedDescription)!)

                break
                
            }
        }
    }
    func successCallBack(response:Any)
    {
        
    }
    func failureCallBack(error:String)
    {
        
    }
    func progressCallBack(progress:Float)
    {
        
    }
}
