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
import SVProgressHUD

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
    fileprivate var imageCaptureManager: ImageCaptureManager?
    var retakeIndexNo = -1
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCameraCapture()
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
    
    /**
     * Method that will initialize the camera for capturing with the AVCaptureVideoPreviewLayer instance
     */
    // Initialization Methods
    func configureCameraCapture() {
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
        if UserDefaults.standard.bool(forKey: "demo_preference") == false {
                getFolderIDFromServer()
        }
    }
    
    /**
     * Method that will update the model consisting of image and its properties
     */
    func updateTotalNoImgLbl() {
        if SharedData.sharedInstance.arrImage.count > 0 {
            lblImageCount.text = String(format:"%d",SharedData.sharedInstance.arrImage.count)
            lblImageCount.isHidden = false
            let newModel = SharedData.sharedInstance.arrImage.last
            lastCatpureImageView.image = newModel?.image!
        } else {
            lblImageCount.isHidden = true
            lastCatpureImageView.image = nil
        }
    }
    
    // MARK: - Button actions
    @IBAction func close() {
        if SharedData.sharedInstance.arrImage.count > 0 {
            let alert = UIAlertController(title: "Exit", message: "Do you want to exit?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: discardScans))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    // Discard all scanned images
    func discardScans(action: UIAlertAction) {
         updateTotalNoImgLbl()
        SharedData.sharedInstance.clearAllData()
        self.navigationController?.popViewController(animated: false)
    }
    
    // Perform segue if scans complete and move to review screen
    @IBAction func scanningDoneTapped(_ sender: Any) {
          if SharedData.sharedInstance.arrImage.count > 0 {
        self.performSegue(withIdentifier: "NavToCompleteScreen", sender: nil)
        }
    }
 
    // Performs the capturing of images manually on camera button click
    @IBAction func capture() {
        self.imageCaptureManager?.isCapturManually = true
        startCapturing()
    }
    
    // Performs toggle of flash button on the camera screen
    @IBAction func flashBtnClicked() {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasTorch {
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOnWithLevel(1.0)
                
                if torchOn {
                    btnTorch.setImage(UIImage(named:"Torch-on"), for: .normal)
                } else {
                    btnTorch.setImage(UIImage(named:"Torch-off"), for: .normal)
                }
                device.torchMode = torchOn ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("error")
            }
        }
    }
    
    // Opens the image preview screen with all scanned images that can either be deleted or retook
    @IBAction func finishScanningTapped(_ sender: Any) {
        guard SharedData.sharedInstance.arrImage.count > 0 else {
            return
        }
        let viewController:ImagePreviewController = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewController") as! ImagePreviewController
        viewController.deleteDelegate = self
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    //MARK :- Capture start
    func startCapturing()
    {
        self.showImageCaptureLoadingView()
        self.imageCaptureManager?.capture(completion: {[weak self] (imageData, detectedQuadrangle) in
            self?.hideImageCaptureLoadingView()
            self?.previewImage(with: imageData, detectedQuadrangle: detectedQuadrangle)
        })
    }
    
    /**
     * Method that will store the image into the Apple device gallery creating an album of itself
     */
    // MARK: - Store Image
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
            else if error != nil {
                // Save album failed with error
            }
            else {
                // Save album failed with no error
            }
        })
    }
    
    // MARK: - Image Capture Handler
    private func showImageCaptureLoadingView() {
        //TODO
        self.view.isUserInteractionEnabled = false
    }
    
    
    private func hideImageCaptureLoadingView() {
        //TODO
        self.view.isUserInteractionEnabled = true
    }
    
    // Crop detected image
    private func previewImage(with imageData: Data?,
                              detectedQuadrangle: Quadrangle?) {
        guard let imageData = imageData else {
            return
        }
        if (self.imageCaptureManager?.isCapturManually)! {
            self.store_uploadImage(image: UIImage(data:imageData)!)
        } else if let detectedQuadrangle = detectedQuadrangle {
            //  show the cropped image
            ImageEditManager.cut(quadrangle: detectedQuadrangle, outOfImageWith: imageData, completion: { (image) in
                self.store_uploadImage(image: image!)
            })
        }
    }
    
    // Store captured images locally in iPhone Gallery and also upload images to OCR server
    func store_uploadImage(image:UIImage) {
        if self.retakeIndexNo != -1 {
            let model = SharedData.sharedInstance.arrImage[self.retakeIndexNo]
            model.image = image
            model.isUploadingInProgress =  true
            SharedData.sharedInstance.arrImage[self.retakeIndexNo] = model
            if UserDefaults.standard.bool(forKey: "demo_preference") {
                //TODO: Demo mode handle
            } else {
                self.callUploadImageApi(indexNo: self.retakeIndexNo)
            }
        }
        else {
            let model = ImageDataModel()
            model.image = image
            model.isUploadingInProgress =  true
            SharedData.sharedInstance.arrImage.append(model)
            if UserDefaults.standard.bool(forKey: "demo_preference") {
                //TODO: Demo mode handle
            } else {
                self.callUploadImageApi(indexNo: SharedData.sharedInstance.arrImage.count - 1)
            }
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
    
    // Aniamtion of image to gallery icon after capturing
    func animateImageAfterCapturing() {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.centerImageView.frame =  CGRect(x: self.galleryView.frame.origin.x + self.galleryBtn.frame.origin.x, y: self.galleryView.frame.origin.y + self.galleryBtn.frame.origin.y, width: self.galleryBtn.frame.size.width, height: self.galleryBtn.frame.size.height)
        },completion: { finish in
            self.centerImageView.isHidden = true
            let model = SharedData.sharedInstance.arrImage.last
            self.lastCatpureImageView.image = model?.image
        })
    }
    
}

// MARK: - Auto Image Capture Handler
extension CameraViewController:ImageCaptureManagerProtocol {
    // Capture image automatically if detection confidence is full
    func didGainFullDetectionConfidence() {
        self.imageCaptureManager?.isCapturManually =  false
        startCapturing()
    }
}

//MARK: - ImageDeleteDelegate methods
extension CameraViewController:ImageDeleteDelegate
{
    // Update model when image deleted
    func updateCollectionWhenImageDeletedAt(index: Int) {
        let model = SharedData.sharedInstance.arrImage[index]
        model.isDeleted = true
        
        if model.imageSuccesfullyUpload == true || model.isUploadingInProgress == false || UserDefaults.standard.bool(forKey: "demo_preference") {
            SharedData.sharedInstance.arrImage.remove(at: index)
        }
        if index == 0 && SharedData.sharedInstance.arrImage.count == 0 {
            lastCatpureImageView.image = nil
        }
        self.updateTotalNoImgLbl()
    }
    
    // Update model when image is retook
    func updateCollectionWhenImageretakeAt(index : Int) {
        if SharedData.sharedInstance.arrImage.count > 0 {
            retakeIndexNo = index
        }
    }
}


//MARK: - UploadImageProxyDelegate methods
extension CameraViewController:UploadImageProxyDelegate {
    // Upload image Api calling function
    func callUploadImageApi(indexNo:Int) {
        let model = SharedData.sharedInstance.arrImage[indexNo]
        let uploadImageProxy =  UploadImageProxy()
        uploadImageProxy.delegate = self
        uploadImageProxy.uploadScanningImage(image: (model.image!), indexNo: indexNo)
    }
    
    //MARK: - Image upload response calls
    func imageSuccessfullyUpload(responseData:[String:AnyObject],indexNo:Int) {
        let isModelValid = SharedData.sharedInstance.arrImage.indices.contains(indexNo)
        if (isModelValid) {
            let model = SharedData.sharedInstance.arrImage[indexNo]
             model.progress = 1

            // Check if image is deleted during uploading process
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
    
    func imageFailedToUpload(errorMessage:String,indexNo:Int) {
        let isModelValid = SharedData.sharedInstance.arrImage.indices.contains(indexNo)
        if (isModelValid) {
            let model = SharedData.sharedInstance.arrImage[indexNo]
             model.isUploadingInProgress =  false
            // Check if image is deleted during deleteing process
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
    
    func progressResult(progress:Float,indexNo:Int) {
        let isModelValid = SharedData.sharedInstance.arrImage.indices.contains(indexNo)
        if (isModelValid) {
            let model = SharedData.sharedInstance.arrImage[indexNo]
            model.progress = progress
            // Check if image is deleted during uploading process
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
extension CameraViewController:GetFolderDetailsDelegate {

    func getFolderIDFromServer()
    {
        SVProgressHUD.show()
        let folderDetailProxy =  GetFolderDetailsProxy()
        folderDetailProxy.delegate = self
        folderDetailProxy.getFolderDetailsFromServer()
    }
    func getfoldereDetailsSuccess(folderId:String)
    {
        SVProgressHUD.dismiss()
        SharedData.sharedInstance.guid = folderId.replacingOccurrences(of: "\"", with: "")
        print (SharedData.sharedInstance.guid)
    }
    func getFolderDetailFailed(errorMessage:String)
    {
        SVProgressHUD.dismiss()
    }
}
