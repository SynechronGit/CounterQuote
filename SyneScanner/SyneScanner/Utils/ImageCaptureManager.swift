//
//  ImageCaptureManager.swift
//  SyneScanner
//
//  Created by Kartik on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import Foundation
import AVFoundation
import CoreVideo
import CoreImage
import UIKit

protocol ImageCaptureManagerProtocol {
    func didGainFullDetectionConfidence()
}
typealias ImageCaptureBlock = (Data?, Quadrangle?) -> Void

class ImageCaptureManager: NSObject {
    
    var didNotifyFullConfidence = false
    
    var isCapturing = false
    var delegate:ImageCaptureManagerProtocol?
    var imageDedectionConfidence = 0.0
    var timer:Timer?
    ///  the view to show the detected edges
    weak var edgeDetectionView: EdgeDetectionView?
    
    ///  the image capture session
    private let captureSession: AVCaptureSession
    
    ///  the capture photo output
    fileprivate let capturePhotoOutput: AVCapturePhotoOutput
    
    ///  the size of the video output image
    fileprivate var videoOutputImageSize: CGSize?
    
    ///  the quadrangle stablizer that stablize the quadrangle
    fileprivate let quadrangleFilter = QuadrangleFilter()
    
    ///  the detected quadrangle
    fileprivate var detectedQuadrangle: Quadrangle?
    
    ///  the image capture block
    fileprivate var imageCaptureBlock: ImageCaptureBlock?
    
    /// the rectange detector that's used to detect the edge of the document
    //TODO: settings
    fileprivate let rectangleDetector = CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
    
    /// Initialize a ImageCaptureManager instance
    /// - parameter layer: the layer that shows the camera feeds
    /// - parameter edgeDetectionView: the view that shows the detected edge
    init?(layer: AVCaptureVideoPreviewLayer,
          edgeDetectionView: EdgeDetectionView) {
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let inputDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let capturePhotoOutput = AVCapturePhotoOutput()
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: inputDevice),
            captureSession.canAddInput(deviceInput),
            captureSession.canAddOutput(capturePhotoOutput),
            captureSession.canAddOutput(videoOutput) else {
                debugPrint("Failed to add the input and output to capture session. Please run this on a real iOS device rather than an iOS simulator.")
                return nil
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(capturePhotoOutput)
        
        layer.session = captureSession
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        self.captureSession = captureSession
        self.capturePhotoOutput = capturePhotoOutput
        self.edgeDetectionView = edgeDetectionView
        
        super.init()
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_output"))
    }
    
    
    /// Start showing the camera feeds
    func resetProperties()
    {
        isCapturing = false
        didNotifyFullConfidence = false
        self.timer?.invalidate()
        self.timer = nil

    }
    func startSession() {
        isCapturing = false
        didNotifyFullConfidence = false
        self.timer?.invalidate()
        self.timer = nil
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authorizationStatus == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {[weak self] (granted) in
                if granted {
                    self?.captureSession.startRunning()
                }
            })
        }
        else if authorizationStatus == .authorized {
            self.captureSession.startRunning()
        }
        else {
            //TODO: present error
        }
    }
    
    
    /// Stop showing the camera feeds
    func stopSession(){
        self.captureSession.stopRunning()
    }
    
    
    /// Capture the image
    /// - parameter completion: the completion block
    func capture(completion: @escaping ImageCaptureBlock){
        if isCapturing
        {
            return
        }
        isCapturing = true
        self.imageCaptureBlock = completion
        let capturePhotoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
        self.capturePhotoOutput.capturePhoto(with: capturePhotoSettings, delegate: self)
    }
    
}


//MARK: AVCapturePhotoCaptureDelegate
extension ImageCaptureManager: AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        DispatchQueue.global().async {[weak self] in
            guard let photoSampleBuffer = photoSampleBuffer,
                let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer),
                let image = CIImage(data: imageData),
                let videoOutputImageSize = self?.videoOutputImageSize else {
                    self?.imageCaptureBlock?(nil, nil)
                    return
            }
            
            if self?.detectedQuadrangle != nil && (self?.detectedQuadrangle?.isValid())! {
                let scale = image.extent.size.width / videoOutputImageSize.width
                let transform = CGAffineTransform(scaleX: scale, y: scale)
                var detectedQuadrangleOnImage = self?.detectedQuadrangle
                detectedQuadrangleOnImage?.applying(transform)
                DispatchQueue.main.async {
                    self?.imageCaptureBlock?(imageData, detectedQuadrangleOnImage)
                }
            }
            else{
                self?.didNotifyFullConfidence = false
                self?.isCapturing = false
                self?.timer?.invalidate()
                self?.timer = nil
                
            }
            
        }
    }
}

//MARK: AVCaptureVideoDataOutputSampleBufferDelegate
extension ImageCaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if isCapturing
        {
            return
        }
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let videoOutputImage = CIImage.init(cvPixelBuffer: pixelBuffer)
        var quadrangle = Quadrangle.zero
        if let rectangeFeatures = self.rectangleDetector?.features(in: videoOutputImage) as? [CIRectangleFeature],
            let biggestRectangeFeature = rectangeFeatures.findBiggestRectangle(){
            quadrangle = biggestRectangeFeature.makeQuadrangle()
        }
        quadrangle = self.quadrangleFilter.filteredQuadrangle(from: quadrangle)
        
        let landscapeImageSize = videoOutputImage.extent.size
        if quadrangle.isValid() {
            
            didNotifyFullConfidence = true
            DispatchQueue.main.async { [weak self] in
                
                self?.videoOutputImageSize = videoOutputImage.extent.size
                self?.detectedQuadrangle = quadrangle
                self?.edgeDetectionView?.showQuadrangle(quadrangle, inLandscapeImageWithSize: landscapeImageSize)
                self?.setEdgeDetectionView(self?.edgeDetectionView, hidden: false)
            }
        }
        else {
            didNotifyFullConfidence = false
            self.timer?.invalidate()
            self.timer = nil
            DispatchQueue.main.async { [weak self] in
                self?.videoOutputImageSize = videoOutputImage.extent.size
                self?.detectedQuadrangle = nil
                self?.setEdgeDetectionView(self?.edgeDetectionView, hidden: true)
            }
        }
    }
    
    private func setEdgeDetectionView(_ edgeDetectionView: EdgeDetectionView?, hidden: Bool){
        
//        if hidden
//        {
//            edgeDetectionView?.alpha = 0
//        }
//        else{
//            edgeDetectionView?.alpha = 0.4
//        }
        
        if self.didNotifyFullConfidence == true && self.timer == nil
        {
            self.timer =   Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.callDelegateAutoCapture), userInfo: nil, repeats: false)
            
        }
                UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                    edgeDetectionView?.alpha = hidden ? 0 : 0.4
        
                }, completion: { (finished: Bool) in
        
        
        
                })
        
        
        
        
    }
    
    func callDelegateAutoCapture()
    {
        self.timer?.invalidate()
        self.timer = nil
        
        if self.didNotifyFullConfidence == true && isCapturing == false
        {
            self.delegate?.didGainFullDetectionConfidence()
            
        }
        
        
    }
}
