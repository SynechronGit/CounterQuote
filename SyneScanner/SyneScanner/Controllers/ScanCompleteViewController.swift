//
//  ScanCompleteViewController.swift
//  SyneScanner
//
//  Created by Kartik on 22/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class ScanCompleteViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIButton action methods

    @IBAction func scanningDoneTapped(_ sender: Any) {
        self.showProgressLoader()
        self.startWorkflowApi()
    }
    
    //MARK: LineProgress methods
    
    func showProgressLoader() {
        if ARSLineProgress.shown { return }
        
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            print("Showed with completion block")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NavToPdfView"
        {
            let vc:PDFViewController = segue.destination as! PDFViewController
            vc.fileName = "policy"
        }
    }
}

extension ScanCompleteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: UICollectionView DataSource methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return SharedData.sharedInstance.arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ImageReviewCollectionViewCell
        let model = SharedData.sharedInstance.arrImage[indexPath.row]
        cell.imageReview.image = model.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.frame.size.width/2 - 20
        let height = width
        return CGSize(width: width, height: height)
    }
    
}

//MARK: StartWorkflowDelegate methods
extension ScanCompleteViewController: StartWorkflowDelegate {
    
    func startWorkflowApi() {
        var blobUrl = ""
        for scanItem in 0..<SharedData.sharedInstance.arrImage.count {
            blobUrl.append(SharedData.sharedInstance.arrImage[scanItem].fileUrl)
            if scanItem != SharedData.sharedInstance.arrImage.count - 1 {
                blobUrl.append(";")
            }
        }
        let startWorkflowProxy =  ImageWorkflowProxy()
        startWorkflowProxy.delegate = self
        startWorkflowProxy.startWorkflowApi(blobUrl: blobUrl, corelationId: SharedData.sharedInstance.corelationId)
    }
    
    func workflowSuccessfullyStarted(responseData: [String : AnyObject]) {
        ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            ARSLineProgress.showSuccess()
            self.performSegue(withIdentifier: "NavToPdfView", sender: nil)
        })
        
    }
    
    func workflowFailedToStart(errorMessage: String) {
        ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            ARSLineProgress.showFail()
            self.performSegue(withIdentifier: "NavToPdfView", sender: nil)

        })
    }
}
