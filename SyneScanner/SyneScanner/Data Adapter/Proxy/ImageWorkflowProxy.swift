//
//  ImageWorkflowProxy.swift
//  SyneScanner
//
//  Created by Kartik on 22/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

protocol StartWorkflowDelegate {
    func workflowSuccessfullyStarted(responseData:[String:AnyObject])
    func workflowFailedToStart(errorMessage:String)
}

class ImageWorkflowProxy: NetworkManager {

    var delegate:StartWorkflowDelegate?
    
    override func successCallBack(response:Any)
    {
        if    let dataArr:[[String:Any]] = response as? [[String : Any]]
        {
            delegate?.workflowSuccessfullyStarted(responseData: dataArr[0] as [String : AnyObject])
            
        }
    }
    override func failureCallBack(error:String)
    {
        delegate?.workflowFailedToStart(errorMessage: error)
    }
    
}
