//
//  ImagePreviewController.swift
//  SyneScanner
//
//  Created by Kartik on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SVProgressHUD

class ImagePreviewController: BaseViewController {
    // MARK: - Properties
    var deleteDelegate : ImageDeleteDelegate?
    var selectedIndexNo = -1
    var progressValue = 0
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var submitBtn: UIButton!
    var progressTimer:Timer?
    @IBOutlet weak var bottomConstraintBackBtn: NSLayoutConstraint!

     // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       configureUI()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Method that will start view animations
     */
    // MARK: - Start Animation
    func startAnimation() {
        leftCurveLeading.constant = -10
        rightaCureveTrailing.constant = -16
        self.bottomConstraintBackBtn.constant = 0
        // Animate collection view cells
        UIView.animate(withDuration: 1.2, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
        }, completion: { finish in
            self.collectionView.layoutIfNeeded()
            self.collectionView.reloadData()
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
                self.collectionView.alpha = 1
                self.pageControl.alpha = 1
                self.lblHeader.alpha = 1
            }, completion:  { finish in
                if UserDefaults.standard.bool(forKey: "demo_preference") == true {
                self.progressTimer =   Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateProgressValue), userInfo: nil, repeats: true)
                }
            })
        })
    }
    
    /**
     * Method that will configure UI intializations
     */
    // MARK: - Configure UI
    func configureUI() {
        self.bottomConstraintBackBtn.constant = -80
        self.collectionView.alpha = 0
        self.pageControl.alpha = 0
        self.lblHeader.alpha = 0
        self.submitBtn.isEnabled = false
        pageControl.numberOfPages = SharedData.sharedInstance.arrImage.count
        submitBtn.setBorderToButton()
        submitBtn.layer.borderColor = UIColor.lightGray.cgColor
        submitBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        lblHeader.text = String(format:"You are in (1/%d) pages",pageControl.numberOfPages)
        
        if UserDefaults.standard.bool(forKey: "demo_preference") == false {

        let notificationName = Notification.Name("updateProgress")
        NotificationCenter.default.addObserver(self, selector: #selector(ImagePreviewController.updateProgress), name: notificationName, object: nil)
            updateProgress()
        }
        collectionView.reloadData()
    }
    
    /**
     * Method that will update the progress of uploading of images
     */
    // MARK: - Progress methods
    @objc func updateProgress() {
         let calculateProgress = SharedData.sharedInstance.calculateCurrentProgress()
        if calculateProgress.progressValue <= 1.0 {
           submitBtn.isEnabled = true
            submitBtn.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
            submitBtn.setTitleColor(UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1), for: .normal)

        } else {
            submitBtn.isEnabled = false
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    //Update progress value of collection view for each cell
    @objc func updateProgressValue() {
        progressValue = progressValue + 10
        if progressValue >= 100 {
            self.submitBtn.isEnabled = true
            submitBtn.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
            submitBtn.setTitleColor(UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1), for: .normal)
            self.progressTimer?.invalidate()
            self.progressTimer = nil
        }
        DispatchQueue.main.async {
        self.collectionView.reloadData()
        }
    }
    
    //MARK: UIButton action methods
    @IBAction func popToRoot() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction  func finishBtnTapped() {
        if UserDefaults.standard.bool(forKey: "demo_preference") {
            self.performSegue(withIdentifier: "NavToLoaderVc", sender: nil)
        } else {
            callCloseFloderApi()
        }
    }
   
}


 // MARK: - UICollection View DataSource and Delegate Method
extension ImagePreviewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SharedData.sharedInstance.arrImage.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagePreviewCollectionViewCell
        var model:ImageDataModel?
        model = SharedData.sharedInstance.arrImage[indexPath.row]
        cell.imagePreview.image = model?.image
        cell.retakeDelegate = self
        if UserDefaults.standard.bool(forKey: "demo_preference") == false {
            cell.progressView.value = CGFloat((model?.progress)! * 100)

        }
        else{
            cell.progressView.value = CGFloat(progressValue)
 
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 60
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        pageControl.currentPage = visibleIndexPath.row
        lblHeader.text = String(format:"You are in (%d/%d) pages",pageControl.currentPage + 1,pageControl.numberOfPages)
        print(visibleIndexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.10
        cell.layer.shadowRadius = 4
    }
}

// MARK: - ImagePreviewCollectionViewCell Delegate Method
extension ImagePreviewController:ImageShareAndRetakeDelegate {
    
    func retakeImageAt(cell : UICollectionViewCell) {
        guard deleteDelegate != nil else {
            return
        }
        let indexPath = self.collectionView.indexPath(for: cell)
        deleteDelegate?.updateCollectionWhenImageretakeAt(index: (indexPath?.row)!)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func deleteImageAt(cell : UICollectionViewCell) {
        guard deleteDelegate != nil else {
            return
        }
        let indexPath = self.collectionView.indexPath(for: cell)
        deleteDelegate?.updateCollectionWhenImageDeletedAt(index: (indexPath?.row)!)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func updateColelctionWhenImageDeletedAt(cell : UICollectionViewCell) {
    }
    
}

//MARK: - ImageDeleteDelegate Protocol
protocol ImageDeleteDelegate {
    func updateCollectionWhenImageDeletedAt(index : Int)
    func updateCollectionWhenImageretakeAt(index : Int)

}

//MARK: StartWorkflowDelegate methods
extension ImagePreviewController: GetFolderDetailsDelegate {
   
    func callCloseFloderApi()
    {
        SVProgressHUD.show()
        let folderDetailProxy =  GetFolderDetailsProxy()
        folderDetailProxy.delegate = self
        folderDetailProxy.closeFolder()
    }
    func closeFolderSuccessfully(response:String)
    {
        SVProgressHUD.dismiss()

        self.performSegue(withIdentifier: "NavToLoaderVc", sender: nil)

    }
    
    func getFolderDetailFailed(errorMessage:String)
    {
        SVProgressHUD.dismiss()
        self.performSegue(withIdentifier: "NavToLoaderVc", sender: nil)

//        self.popupAlert(title: "Error", message: errorMessage, actionTitles: ["Dismiss"], actions:[{action1 in
//            
//            }, nil])
    }

}


