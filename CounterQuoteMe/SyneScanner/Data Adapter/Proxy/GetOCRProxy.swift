//
//  GetOCRProxy.swift
//  SyneScanner
//
//  Created by Markel on 06/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
//MARK: - GetOCRProxyDelgate protocol
protocol GetOCRProxyDelgate {
    func getOCRSuccess(responseData:[String:AnyObject])
    func getOCRFailed(errorMessage:String)
}

class GetOCRProxy: NetworkManager {
    //MARK: - Properties
    var delegate:GetOCRProxyDelgate?
    
    //MARK: - OCR Api methods
    func callGetOCRApi() {
        let url = GET_EXTRACTED_DATA + SharedData.sharedInstance.guid
        super.callGetMethod(headers: [:], url: url)
    }
    
    //MARK: - Response callback methods
    override func successCallBack(response:Any) {
        if    let dataArr:[[String:AnyObject]] = response as? [[String : AnyObject]] {
            delegate?.getOCRSuccess(responseData: dataArr[0] as [String : AnyObject] )
        } else {
            delegate?.getOCRFailed(errorMessage: "Something went wrong.")
        }
    }
    
    override func failureCallBack(error:String) {
        delegate?.getOCRFailed(errorMessage: error)
    }
}
