//
//  StartWorkFlowViewController.swift
//  SyneScanner
//
//  Created by Markel on 25/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class StartWorkFlowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showProgressLoader()
        self.startWorkflowApi()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startWorkflowApi() {
        var blobUrl: String?
        for scanItem in SharedData.sharedInstance.arrImage {
            blobUrl?.append(scanItem.fileUrl + ";")
        }
        guard (blobUrl != nil) else {
            return
        }
        let startWorkflowProxy =  ImageWorkflowProxy()
        startWorkflowProxy.delegate = self
        startWorkflowProxy.startWorkflowApi(blobUrl: blobUrl!, corelationId: SharedData.sharedInstance.corelationId)
    }
    
    //MARK: LineProgress methods
    
    func showProgressLoader() {
        if ARSLineProgress.shown { return }
        
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            print("Showed with completion block")
        }
    }

}

//MARK: StartWorkflowDelegate methods
extension StartWorkFlowViewController: StartWorkflowDelegate {
    func workflowSuccessfullyStarted(responseData: [String : AnyObject]) {
        ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            ARSLineProgress.showSuccess()
        })
    }
    
    func workflowFailedToStart(errorMessage: String) {
        ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            ARSLineProgress.showFail()
        })
    }
}
