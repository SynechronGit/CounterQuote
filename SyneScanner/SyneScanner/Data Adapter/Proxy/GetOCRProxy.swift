//
//  GetOCRProxy.swift
//  SyneScanner
//
//  Created by Markel on 06/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

protocol GetOCRProxyDelgate {
    func getOCRSuccess(responseData:[String:AnyObject])
    func getOCRFailed(errorMessage:String)
}

class GetOCRProxy: NetworkManager {
    
  var delegate:GetOCRProxyDelgate?
    
    func callGetOCRApi(corelationId: String) {
        let url = GET_OCR + corelationId          
        super.callGetMethod(url: url)
    }
    
    override func successCallBack(response:Any, statusCode:Int)
    {
        if    let dataArr:[[String:Any]] = response as? [[String : Any]]
        {
            delegate?.getOCRSuccess(responseData: dataArr[0] as [String : AnyObject] )
            
        }
        else{
            delegate?.getOCRFailed(errorMessage: "Something went wrong")
 
        }
    }
    override func failureCallBack(error:String,statusCode:Int)
    {
        delegate?.getOCRFailed(errorMessage: error)

    }
}
