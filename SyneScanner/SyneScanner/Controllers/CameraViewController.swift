//
//  CameraViewController.swift
//  SyneScanner
//
//  Created by Kartik on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import AVFoundation

/// The view controller that display the camera feeds and shows the edges of the document if detected.
class CameraViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var edgeDetectionView: EdgeDetectionView!
    @IBOutlet var galleryBtn: UIButton!
    @IBOutlet var centerImageView: UIImageView!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var lblImageCount: UILabel!

    /// the image capture manager
  fileprivate   var imageCaptureManager: ImageCaptureManager?
    
    var retakeIndexNo = -1
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let captureVideoPreviewLayer = self.view.layer as? AVCaptureVideoPreviewLayer {
            self.imageCaptureManager = ImageCaptureManager(layer: captureVideoPreviewLayer,
                                                           edgeDetectionView:self.edgeDetectionView)
            self.imageCaptureManager?.delegate = self
        }
        else {
            debugPrint("The layer of the root view must be a subclass of AVCaptureVideoPreviewLayer")
        }

        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        let myBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        myBackButton.setBackgroundImage(UIImage(named: "Close"), for: .normal)
        myBackButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        myBackButton.sizeThatFits(CGSize(width: 22, height: 22))
        //Add close button to navigationBar as left Button
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        self.imageCaptureManager?.startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.imageCaptureManager?.stopSession()
    }
    
    // MARK: - Button actions
    
    func close() {
        if SharedData.sharedInstance.arrImage.count > 0 {
            let alert = UIAlertController(title: "Discard", message: "Do you want to discard \(SharedData.sharedInstance.arrImage.count) pictures?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: discardScans))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func discardScans(action: UIAlertAction) {
        
        lblImageCount.text = "0"
        SharedData.sharedInstance.clearAllData()
        //self.galleryBtn.setImage(nil, for: .normal)
       // self.dismiss(animated: true, completion: nil)
    }
    @IBAction func scanningDoneTapped(_ sender: Any) {
          if SharedData.sharedInstance.arrImage.count > 0 {
        self.performSegue(withIdentifier: "NavToCompleteScreen", sender: nil)
        }
    }
 
    @IBAction func capture() {
        self.imageCaptureManager?.isCapturManually = true
        startCapturing()
        
    }
    
    func startCapturing()
    {
        self.showImageCaptureLoadingView()
        self.imageCaptureManager?.capture(completion: {[weak self] (imageData, detectedQuadrangle) in
            self?.hideImageCaptureLoadingView()
            self?.previewImage(with: imageData, detectedQuadrangle: detectedQuadrangle)
        })
    }
    @IBAction func finishScanningTapped(_ sender: Any) {
        guard SharedData.sharedInstance.arrImage.count > 0 else {
            //TODO: display error
            return
        }
        let viewController:ImagePreviewController = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewController") as! ImagePreviewController
        viewController.deleteDelegate = self
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    // MARK: - Image Capture Handler
    private func showImageCaptureLoadingView(){
        //TODO
        self.view.isUserInteractionEnabled = false
    }
    
    private func hideImageCaptureLoadingView(){
        //TODO
        self.view.isUserInteractionEnabled = true
    }
    
    private func previewImage(with imageData: Data?,
                              detectedQuadrangle: Quadrangle?) {
        guard let imageData = imageData else {
            //TODO: display error
            return
        }
        if (self.imageCaptureManager?.isCapturManually)!
        {
            self.storeNuploadImage(image: UIImage(data:imageData)!)

        }
       else  if let detectedQuadrangle = detectedQuadrangle {
            //  show the cropped image
            
            ImageEditManager.cut(quadrangle: detectedQuadrangle, outOfImageWith: imageData, completion: { (image) in
                self.storeNuploadImage(image: image!)
                
              //  self.previewCapturedImage()
            })
        }
    }
    
    func storeNuploadImage(image:UIImage)
    {
        //self.galleryBtn.setImage(image, for: .normal)
        if self.retakeIndexNo != -1
        {
            let model = SharedData.sharedInstance.arrImage[self.retakeIndexNo]
            model.image = image
            SharedData.sharedInstance.arrImage[self.retakeIndexNo] = model
            self.callUploadImageApi(indexNo: self.retakeIndexNo)
            
        }
        else{
            let model = ImageDataModel()
            model.image = image
            SharedData.sharedInstance.arrImage.append(model)
            self.callUploadImageApi(indexNo: SharedData.sharedInstance.arrImage.count - 1)
            
        }
        self.retakeIndexNo = -1
        self.centerImageView.isHidden = false
        self.centerImageView.frame = CGRect(x: self.view.frame.size.width/2 - 60 , y: self.view.frame.size.height/2 - 80, width: 120, height: 120)
        self.centerImageView.image = image
        self.imageCaptureManager?.resetProperties()
        lblImageCount.text = String(format:"%d",SharedData.sharedInstance.arrImage.count)

        self.animateImageAfterCapturing()

    }
    func animateImageAfterCapturing()
    {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            self.centerImageView.frame =  CGRect(x: self.galleryView.frame.origin.x + self.galleryBtn.frame.origin.x, y: self.galleryView.frame.origin.y + self.galleryBtn.frame.origin.y, width: self.galleryBtn.frame.size.width, height: self.galleryBtn.frame.size.height)
            
         
            
        },completion: { finish in
            self.centerImageView.isHidden = true
//            self.galleryBtn.isHidden = true
//            UIView.animate(withDuration: 0.5, delay: 0.0,options: UIViewAnimationOptions.curveEaseOut,animations: {
//                self.centerImageView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
//                
//                
//            },completion: { finish in
//                self.centerImageView.image = nil
//                self.centerImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
//                self.galleryBtn.isHidden = false
//            }
//            )
        })
        
    }
    
    
 
}

// MARK: - Auto Image Capture Handler

extension CameraViewController:ImageCaptureManagerProtocol
{
    func didGainFullDetectionConfidence()
    {
        self.imageCaptureManager?.isCapturManually =  false

        startCapturing()
    }
}

extension CameraViewController:ImageDeleteDelegate
{
    func updateCollectionWhenImageDeletedAt(index: Int) {
        if SharedData.sharedInstance.arrImage.count > 0 {
            retakeIndexNo = index
        }
        
    }
    func updateCollectionWhenImageretakeAt(index : Int)
    {
        SharedData.sharedInstance.arrImage.remove(at: index)
        lblImageCount.text = String(format:"%d",SharedData.sharedInstance.arrImage.count)

    }
}



extension CameraViewController:UploadImageProxyDelegate
{
    func callUploadImageApi(indexNo:Int)
    {
        let model = SharedData.sharedInstance.arrImage[indexNo]

        let uploadImageProxy =  UploadImageProxy()
        uploadImageProxy.delegate = self
        uploadImageProxy.uploadScanningImage(image: model.image!, indexNo: indexNo)
    }
    func imageSuccessfullyUpload(responseData:[String:AnyObject],indexNo:Int)
    {
        SharedData.sharedInstance.updateModel(dict: responseData, indexNo: indexNo)
        let notificationName = Notification.Name("updateProgress")
        NotificationCenter.default.post(name: notificationName, object: nil)

    }
    func imageFailedToUpload(errorMessage:String,indexNo:Int)
    {
        
    }
    func progressResult(progress:Float,indexNo:Int)
    {
         let model = SharedData.sharedInstance.arrImage[indexNo]
        model.progress = progress
        SharedData.sharedInstance.arrImage[indexNo] = model
        let notificationName = Notification.Name("updateProgress")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    
}
