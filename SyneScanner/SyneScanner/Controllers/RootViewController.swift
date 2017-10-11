//
//  RootViewController.swift
//  SyneScanner
//
//  Created by Markel on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import DKImagePickerController
class RootViewController: BaseViewController {

    // MARK: - Properties
    @IBOutlet weak var btnScanDocument: UIButton!
    @IBOutlet weak var btngallery: UIButton!

    @IBOutlet weak var topConstraintLblHeader: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintScanDocBtn: NSLayoutConstraint!
    @IBOutlet weak var lblWelcomeNote: UILabel!
    @IBOutlet weak var imgViewphonLogo: UIImageView!
    let pickerController = DKImagePickerController()

    // MARK: - View LifeCycle
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
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
   
    // MARK: - Animation methods
   func startAnimation() {
        leftCurveLeading.constant = -10
        rightaCureveTrailing.constant = -16
        self.topConstraintLblHeader.constant = 30
        self.bottomConstraintScanDocBtn.constant = 20

        UIView.animate(withDuration: 1.0, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
        }, completion: { finish in
          
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.lblWelcomeNote.alpha = 1.0
                self.imgViewphonLogo.alpha = 1.0

            }, completion: nil)
            })
    }
    
    // MARK: - ConfigureUI
    func configureUI()
    {
        pickerController.sourceType = .photo
        btnScanDocument.setBorderToButton()
        btngallery.setBorderToButton()

        bottomConstraintScanDocBtn.constant = -80
        topConstraintLblHeader.constant = -50
        lblWelcomeNote.alpha = 0
        imgViewphonLogo.alpha = 0

        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.uploadImage(imgArray: assets)
        }

    }
    // MARK: - Button Actions
    @IBAction func startScanning() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController")
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    @IBAction func uploadBtnClicked() {
        self.present(pickerController, animated: true) {}

    }
    
    //MARK: - Upload Image
    func uploadImage(imgArray:[DKAsset]) {
              if imgArray.count > 0
        {
            
            for asset in imgArray {
                asset.fetchOriginalImageWithCompleteBlock({ (image, info) in
                    let model = ImageDataModel()
                    model.image = image
                    model.imageSuccesfullyUpload = true
                    SharedData.sharedInstance.arrImage.append(model)
                    // self.callUploadImageApi(indexNo: SharedData.sharedInstance.arrImage.count - 1)
                })
            }

            let imageReviewViewController:ImagePreviewController = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewController") as! ImagePreviewController
            
            self.navigationController?.pushViewController(imageReviewViewController, animated: true)
            
        }
      
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
