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
    func callGetOCRApi(corelationId: String) {
        let url = GET_OCR + corelationId
        let headers = ["Authorization": SharedData.sharedInstance.authToken]
        super.callGetMethod(headers: headers as! [String : String], url: url)
    }
    
    //MARK: - Response callback methods
    override func successCallBack(response:Any) {
        if    let dataArr:[[String:Any]] = response as? [[String : Any]] {
            delegate?.getOCRSuccess(responseData: dataArr[0] as [String : AnyObject] )
        } else {
            delegate?.getOCRFailed(errorMessage: "Something went wrong.")
        }
    }
    
    override func failureCallBack(error:String) {
        delegate?.getOCRFailed(errorMessage: error)
    }
}
