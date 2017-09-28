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
    @IBOutlet weak var progressPercentageLabel: UILabel!
    @IBOutlet weak var progressPendingLabel: UILabel!

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        updateProgress()
    }
    func configureUI()
    {
        self.title = "Scan Complete"
        
        
        //Create back button of type custom
        
        //Create back button of type custom
        let myBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        myBackButton.setBackgroundImage(UIImage(named: "BackArrow"), for: .normal)
        myBackButton.addTarget(self, action: #selector(ImagePreviewController.popToRoot), for: .touchUpInside)
        myBackButton.sizeThatFits(CGSize(width: 22, height: 22))
        
        //Add back button to navigationBar as left Button
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        let notificationName = Notification.Name("updateProgress")
        NotificationCenter.default.addObserver(self, selector: #selector(ScanCompleteViewController.updateProgress), name: notificationName, object: nil)

    }
    func popToRoot()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateProgress()
    {
        let calculateProgress = SharedData.sharedInstance.calculateCurrentProgress()
        progressBar.value =  CGFloat(calculateProgress.progressValue)
        let totalProgressPercentage = Int(calculateProgress.progressValue * 100)
        progressPercentageLabel.text = String(format:"%d %% Complete",totalProgressPercentage)
        progressPendingLabel.text = String("\(Int(calculateProgress.uploadedImgCount)) of \(SharedData.sharedInstance.arrImage.count)")
        if progressBar.value >= 1.0
        {
            btnComplete.isEnabled = true
            btnComplete.backgroundColor = UIColor(red: 208/255, green: 64/255, blue: 67/255, alpha: 1.0)
        }
        else {
         //   btnComplete.isEnabled = false

        }
        collectionView.reloadData()
 
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
        if segue.identifier == "NavToPreviewImage"
        {
            let indexPath:IndexPath = sender as! IndexPath
            let vc:ImagePreviewController = segue.destination as! ImagePreviewController
            vc.isFromScanComplete = true
            vc.selectedIndexNo = indexPath.row
            let cameraVc = self.navigationController?.viewControllers[2]
            vc.deleteDelegate = cameraVc as? ImageDeleteDelegate
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
        if model.imageSuccesfullyUpload {
            cell.imageUploadingStatus.image = UIImage(named: "check+right")
        }
        else{
            cell.imageUploadingStatus.image = UIImage(named: "uncheck")
 
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (collectionView.frame.size.width - 6)/4
        let height = width
        print(width)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "NavToPreviewImage", sender: indexPath)
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
                      self.performSegue(withIdentifier: "NavToQuoteView", sender: nil)
                    return
            }
            
            self.ars_launchTimer()
        })
    }
    
}

