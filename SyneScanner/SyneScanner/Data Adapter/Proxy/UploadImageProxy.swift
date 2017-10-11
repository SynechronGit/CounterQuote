//
//  UploadImageProxy.swift
//  SyneScanner
//
//  Created by Markel on 21/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
protocol UploadImageProxyDelegate {
    func imageSuccessfullyUpload(responseData:[String:AnyObject],indexNo:Int)
    func imageFailedToUpload(errorMessage:String,indexNo:Int)
    func progressResult(progress:Float,indexNo:Int)
}
class UploadImageProxy: NetworkManager {

    var delegate:UploadImageProxyDelegate?
    var currentIndex:Int?
    func uploadScanningImage(image:UIImage,indexNo:Int)   {
        currentIndex = indexNo
        super.uploadImage(url: UPLOAD_IMAGE, image: image)
    }
    override func successCallBack(response:Any)
    {
    if    let dataArr:[[String:Any]] = response as? [[String : Any]]
    {
        delegate?.imageSuccessfullyUpload(responseData: dataArr[0] as [String : AnyObject] ,indexNo: currentIndex!)
  
    }
    }
    override func failureCallBack(error:String)
    {
        delegate?.imageFailedToUpload(errorMessage: error,indexNo: currentIndex!)
    }
    override func progressCallBack(progress:Float)
    {
        delegate?.progressResult(progress: progress, indexNo: currentIndex!)
    }
}
