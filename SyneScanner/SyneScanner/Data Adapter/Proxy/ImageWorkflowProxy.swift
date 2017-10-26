//
//  ImageWorkflowProxy.swift
//  SyneScanner
//
//  Created by Kartik on 22/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

//MARK: - StartWorkflowDelegate protocol
protocol StartWorkflowDelegate {
    func workflowSuccessfullyStarted(responseData:String)
    func workflowFailedToStart(errorMessage:String)
}

class ImageWorkflowProxy: NetworkManager {
    //MARK: - Properties
    var delegate:StartWorkflowDelegate?
    
    //MARK: - Start Workflow Api methods
    func startWorkflowApi(blobUrl: String, corelationId: String) {
        let headers = ["Authorization": SharedData.sharedInstance.authToken]
        let parameters = ["BlobUrl": blobUrl, "CorelationId": corelationId]
        super.callPostMethod(headers: headers as! [String : String], paramaters: parameters, url: START_WORKFLOW)
    }
    
    //MARK: - Response callback methods
    override func successCallBack(response:Any){
        delegate?.workflowSuccessfullyStarted(responseData: "Success")
    }
    
    override func failureCallBack(error:String) {
        delegate?.workflowFailedToStart(errorMessage: error)
    }
    
}
