//
//  CameraViewController.swift
//  SyneScanner
//
//  Created by Kartik on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
/// The view controller that display the camera feeds and shows the edges of the document if detected.
class CameraViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet var edgeDetectionView: EdgeDetectionView!
    @IBOutlet var galleryBtn: UIButton!
    @IBOutlet var doneBtn: UIButton!
    @IBOutlet var btnTorch: UIButton!

    @IBOutlet var centerImageView: UIImageView!
    @IBOutlet var lastCatpureImageView: UIImageView!

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

        lastCatpureImageView.layer.masksToBounds = false
        lastCatpureImageView.layer.cornerRadius = 20
        lastCatpureImageView.clipsToBounds = true
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
       updateTotalNoImgLbl()

        self.imageCaptureManager?.startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.imageCaptureManager?.stopSession()
    }
    
    func updateTotalNoImgLbl()
    {
        if SharedData.sharedInstance.arrImage.count > 0
        {
            lblImageCount.text = String(format:"%d",SharedData.sharedInstance.arrImage.count)
            lblImageCount.isHidden = false
            let newModel = SharedData.sharedInstance.arrImage.last
            lastCatpureImageView.image = newModel?.image!
        }
        else
        {
            lblImageCount.isHidden = true
            lastCatpureImageView.image = nil

        }
    }
    // MARK: - Button actions
    
    @IBAction func close() {
        if SharedData.sharedInstance.arrImage.count > 0
        {
            
              let alert = UIAlertController(title: "Exit", message: "Do you want to exit?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: discardScans))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func discardScans(action: UIAlertAction) {
         updateTotalNoImgLbl()
        SharedData.sharedInstance.clearAllData()
        self.navigationController?.popViewController(animated: false)
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
    
    @IBAction func flashBtnClicked()
    {
        
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasTorch {
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOnWithLevel(1.0)
                
                if torchOn
                {
                    
                    btnTorch.setImage(UIImage(named:"Torch-on"), for: .normal)


                }
                else{
                    btnTorch.setImage(UIImage(named:"Torch-off"), for: .normal)

                }
                device.torchMode = torchOn ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("error")
            }
        }
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
    
    // MARK: - Store Image into Gallery
    func createPhotoLibraryAlbum(name: String) {
        var albumPlaceholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            // Request creating an album with parameter name
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
            // Get a placeholder for the new album
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { success, error in
            if success {
                guard let placeholder = albumPlaceholder else {
                    fatalError("Album placeholder is nil")
                }
                
                let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                guard let album: PHAssetCollection = fetchResult.firstObject else {
                    // FetchResult has no PHAssetCollection
                    return
                }
                
                // Saved successfully!
                print(album.assetCollectionType)
            }
            else if let e = error {
                // Save album failed with error
            }
            else {
                // Save album failed with no error
            }
        })
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
            self.store_uploadImage(image: UIImage(data:imageData)!)

        }
       else  if let detectedQuadrangle = detectedQuadrangle {
            //  show the cropped image
            
            ImageEditManager.cut(quadrangle: detectedQuadrangle, outOfImageWith: imageData, completion: { (image) in
                self.store_uploadImage(image: image!)
                
              //  self.previewCapturedImage()
            })
        }
    }
    
    func store_uploadImage(image:UIImage)
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
       updateTotalNoImgLbl()

        self.animateImageAfterCapturing()
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)


    }
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
     
    }
    func animateImageAfterCapturing()
    {
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            self.centerImageView.frame =  CGRect(x: self.galleryView.frame.origin.x + self.galleryBtn.frame.origin.x, y: self.galleryView.frame.origin.y + self.galleryBtn.frame.origin.y, width: self.galleryBtn.frame.size.width, height: self.galleryBtn.frame.size.height)
            
         
            
        },completion: { finish in
            self.centerImageView.isHidden = true
            let model = SharedData.sharedInstance.arrImage.last
            self.lastCatpureImageView.image = model?.image
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
        
        let model = SharedData.sharedInstance.arrImage[index]
        model.isDeleted = true
        if model.imageSuccesfullyUpload == true {
            SharedData.sharedInstance.arrImage.remove(at: index)
        }

        if index == 0 && SharedData.sharedInstance.arrImage.count == 0 {
            lastCatpureImageView.image = nil
        }
        self.updateTotalNoImgLbl()
    }
    func updateCollectionWhenImageretakeAt(index : Int)
    {
       
        if SharedData.sharedInstance.arrImage.count > 0 {
            retakeIndexNo = index
        }
    }
}



extension CameraViewController:UploadImageProxyDelegate
{
    func callUploadImageApi(indexNo:Int)
    {
        let model = SharedData.sharedInstance.arrImage[indexNo]

        let uploadImageProxy =  UploadImageProxy()
        uploadImageProxy.delegate = self
        uploadImageProxy.uploadScanningImage(image: (model.image!), indexNo: indexNo)
    }
    func imageSuccessfullyUpload(responseData:[String:AnyObject],indexNo:Int)
    { 
        let isModelValid = SharedData.sharedInstance.arrImage.indices.contains(indexNo)
        if (isModelValid) {
            let model = SharedData.sharedInstance.arrImage[indexNo]
            if (model.isDeleted) {
                NetworkManager.cancelUploadRequest(index: indexNo)
                SharedData.sharedInstance.arrImage.remove(at: indexNo)
                lblImageCount.text = String(format:"%d",SharedData.sharedInstance.arrImage.count)
            } else {
                SharedData.sharedInstance.updateModel(dict: responseData, indexNo: indexNo)
                let notificationName = Notification.Name("updateProgress")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
        } else {
            lastCatpureImageView.image = nil
        }
        self.updateTotalNoImgLbl()
    }
    func imageFailedToUpload(errorMessage:String,indexNo:Int)
    {
        let isModelValid = SharedData.sharedInstance.arrImage.indices.contains(indexNo)
        if (isModelValid) {
            let model = SharedData.sharedInstance.arrImage[indexNo]
            if (model.isDeleted) {
                NetworkManager.cancelUploadRequest(index: indexNo)
                SharedData.sharedInstance.arrImage.remove(at: indexNo)
                lblImageCount.text = String(format:"%d",SharedData.sharedInstance.arrImage.count)
            }
        } else {
            lastCatpureImageView.image = nil
        }
        self.updateTotalNoImgLbl()
    }
    func progressResult(progress:Float,indexNo:Int)
    {
        let isModelValid = SharedData.sharedInstance.arrImage.indices.contains(indexNo)
        if (isModelValid) {
            let model = SharedData.sharedInstance.arrImage[indexNo]
            model.progress = progress
            if (model.isDeleted) {
                NetworkManager.cancelUploadRequest(index: indexNo)
                SharedData.sharedInstance.arrImage.remove(at: indexNo)
                lblImageCount.text = String(format:"%d",SharedData.sharedInstance.arrImage.count)
            } else {
                SharedData.sharedInstance.arrImage[indexNo] = model
                let notificationName = Notification.Name("updateProgress")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
        } else {
            lastCatpureImageView.image = nil
        }
        self.updateTotalNoImgLbl()
    }
    
}
