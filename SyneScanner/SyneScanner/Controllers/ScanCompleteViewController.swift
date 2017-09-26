//
//  ScanCompleteViewController.swift
//  SyneScanner
//
//  Created by Kartik on 22/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import TCProgressBar

class ScanCompleteViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var progressBar: TCProgressBar!
    @IBOutlet var btnComplete: UIButton!

    var progressObject: Progress?
    var isSuccess: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
      configureUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureUI()
    {
        self.title = "Scan Complete"
        
        
        //Create back button of type custom
        
        let myBackButton:UIButton = UIButton.init(type: .custom)
        myBackButton.addTarget(self, action: #selector(ScanCompleteViewController.popToRoot), for: .touchUpInside)
        myBackButton.setImage(UIImage(named: "BackArrow"), for: .normal)
        myBackButton.sizeToFit()
        
        //Add back button to navigationBar as left Button
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        let notificationName = Notification.Name("updateProgress")
        NotificationCenter.default.addObserver(self, selector: #selector(ScanCompleteViewController.updateProgress), name: notificationName, object: nil)
        updateProgress()

    }
    func popToRoot()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateProgress()
    {
        progressBar.value =  CGFloat(SharedData.sharedInstance.calculateCurrentProgress())
        if progressBar.value >= 1.0
        {
            btnComplete.isEnabled = true
            btnComplete.alpha = 1.0
        }
        else {
            btnComplete.alpha = 0.5
  
        }
 
    }
    //MARK: UIButton action methods

    @IBAction func scanningDoneTapped(_ sender: Any) {
        self.showProgressLoader()
        self.startWorkflowApi()
    }
    
    //MARK: LineProgress methods
    
    func showProgressLoader() {
        if ARSLineProgress.shown { return }
        
        progressObject = Progress(totalUnitCount: 100)
        ARSLineProgress.showWithProgressObject(progressObject!, completionBlock: {
            print("Success completion block")
        })
        
        progressDemoHelper(success: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NavToPdfView"
        {
            let vc:PDFViewController = segue.destination as! PDFViewController
            vc.fileName = "policy"
            vc.navTitle = "Quote"
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
//        ARSLineProgress.hideWithCompletionBlock({ () -> Void in
//            ARSLineProgress.showSuccess()
//            self.performSegue(withIdentifier: "NavToPdfView", sender: nil)
//        })
        
    }
    
    func workflowFailedToStart(errorMessage: String) {
//        ARSLineProgress.hideWithCompletionBlock({ () -> Void in
//            ARSLineProgress.showFail()
//            self.performSegue(withIdentifier: "NavToPdfView", sender: nil)
//
//        })
    }
}



extension ScanCompleteViewController {
    
     func progressDemoHelper(success: Bool) {
        isSuccess = success
        ars_launchTimer()
    }
    
    fileprivate func ars_launchTimer() {
        let dispatchTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.progressObject!.completedUnitCount += Int64(arc4random_uniform(30))
            
            
                if Double((self.progressObject?.fractionCompleted)!) >= 1.0 {
                      self.performSegue(withIdentifier: "NavToPdfView", sender: nil)
                    return
            }
            
            self.ars_launchTimer()
        })
    }
    
}

