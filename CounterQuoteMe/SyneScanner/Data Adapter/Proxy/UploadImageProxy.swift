//
//  UploadImageProxy.swift
//  SyneScanner
//
//  Created by Markel on 21/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

//MARK: - UploadImageProxyDelegate protocol
protocol UploadImageProxyDelegate {
    func imageSuccessfullyUpload(responseData:[String:AnyObject],indexNo:Int)
    func imageFailedToUpload(errorMessage:String,indexNo:Int)
    func progressResult(progress:Float,indexNo:Int)
}

class UploadImageProxy: NetworkManager {
    //MARK: - Properties
    var delegate:UploadImageProxyDelegate?
    var currentIndex:Int?
    
    //MARK: - Upload scan methods
    func uploadScanningImage(image:UIImage,indexNo:Int)   {
        currentIndex = indexNo
      //  let headers = ["Authorization": SharedData.sharedInstance.authToken]
        let url = String(format: "%@%@/Document",UPLOAD_IMAGE,SharedData.sharedInstance.guid)
        super.uploadImage(headers: [:], url: url, image: image)
    }
    
    //MARK: - Response callback methods
    override func successCallBack(response:Any) {
        delegate?.imageSuccessfullyUpload(responseData: response as! [String : AnyObject] ,indexNo: currentIndex!)
        
    }
    
    override func failureCallBack(error:String) {
        delegate?.imageFailedToUpload(errorMessage: error,indexNo: currentIndex!)
    }
    
    override func progressCallBack(progress:Float) {
        delegate?.progressResult(progress: progress, indexNo: currentIndex!)
    }
}
