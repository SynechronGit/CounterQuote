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

    /// the image capture manager
    private var imageCaptureManager: ImageCaptureManager?
    
    var retakeIndexNo = -1
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.imageCaptureManager?.startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.imageCaptureManager?.stopSession()
    }
    
    // MARK: - Button actions
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
 

    @IBAction func capture() {
        
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
        if let detectedQuadrangle = detectedQuadrangle {
            //  show the cropped image
            
            ImageEditManager.cut(quadrangle: detectedQuadrangle, outOfImageWith: imageData, completion: { (image) in
                
                self.galleryBtn.setImage(image, for: .normal)
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
                self.centerImageView.frame = CGRect(x: self.view.frame.size.width/2 - 60 , y: self.view.frame.size.height/2 - 80, width: 120, height: 120)
                self.centerImageView.image = image
                self.imageCaptureManager?.resetProperties()
                self.animateImageAfterCapturing()

              //  self.previewCapturedImage()
            })
        }
    }
    
    func animateImageAfterCapturing()
    {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            self.centerImageView.frame =  self.galleryBtn.frame
            
         
            
        },completion: { finish in
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
        capture()
    }
}

extension CameraViewController:ImageDeleteDelegate
{
    func updateCollectionWhenImageDeletedAt(index: Int) {
        if SharedData.sharedInstance.arrImage.count > 0 {
            let model = SharedData.sharedInstance.arrImage.last
            self.galleryBtn.setImage(model?.image, for: .normal)
            retakeIndexNo = index
        } else {
            self.galleryBtn.setImage(nil, for: .normal)
        }
    }
}

extension CameraViewController:ImageUploadOnBackActionDelegate
{
    func uploadImageOnBackAction() {
        self.callUploadImageApi(indexNo: SharedData.sharedInstance.arrImage.count - 1)
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
    }
    func imageFailedToUpload(errorMessage:String,indexNo:Int)
    {
        
    }
    func progressResult(progress:Float,indexNo:Int)
    {
         let model = SharedData.sharedInstance.arrImage[indexNo]
        model.progress = progress
        SharedData.sharedInstance.arrImage[indexNo] = model
    }

    
}
