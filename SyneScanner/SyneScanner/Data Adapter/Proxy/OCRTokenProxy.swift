//
//  GetTokenProxy.swift
//  SyneScanner
//
//  Created by Kartik on 24/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

//MARK: - GetTokenDelgate protocol
protocol OCRTokenDelegate {
    func getTokenSuccess(responseData:[String:AnyObject])
    func getTokenFailed(errorMessage:String)
}

class OCRTokenProxy: NetworkManager {
    //MARK: - Properties
    var delegate:OCRTokenDelegate?
    
    //MARK: - OCR Token Api methods
    func startOCRTokenApi(userName: String, password: String, grantType: String) {
        let parameters = ["UserName": userName, "Password": password, "grant_type": grantType]
        let headers = ["Content-Type": "x-www-form-urlencoded"]
        super.callPostMethod(headers: headers, paramaters: parameters, url: GET_TOKEN)
    }
    
    //MARK: - Response callback methods
    override func successCallBack(response:Any) {
        if let dataArr = response as? [String:Any] {
            delegate?.getTokenSuccess(responseData: dataArr as [String : AnyObject] )
        } else {
            delegate?.getTokenFailed(errorMessage: "Something went wrong.")
        }
    }
    
    override func failureCallBack(error:String)
    {
        delegate?.getTokenFailed(errorMessage: error)
        
    }
}
