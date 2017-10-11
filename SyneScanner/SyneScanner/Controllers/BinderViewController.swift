//
//  BinderViewController.swift
//  SyneScanner
//
//  Created by Markel on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD
class BinderViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet var webView: UIWebView!
    @IBOutlet var proceedBtn: UIButton!
    @IBOutlet var centerView: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var bottomConstraintcompleteBtn: NSLayoutConstraint!

    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Method that will configure UI initializations
     */
    // MARK: - Configure UI
    func configureUI() {
        self.bottomConstraintcompleteBtn.constant = -47
        self.centerView.alpha = 0
        proceedBtn.setBorderToButton()
        
        centerView.layer.cornerRadius = 10
        centerView.layer.masksToBounds = true
        loadPdfFile()
    }
    
    /**
     * Method that will load the PDF file
     */
    func loadPdfFile() {
        if let pdf = Bundle.main.url(forResource: "Binder", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
    }
    
    /**
     * Method that will start view animations
     */
    //MARK: - Start animation
    func startAnimation() {
        leftCurveLeading.constant = -10
        rightaCureveTrailing.constant = -16
        self.bottomConstraintcompleteBtn.constant = 20
        UIView.animate(withDuration: 1.2, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
        }, completion: { finish in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
                self.centerView.alpha = 1
            }, completion:  { finish in
            })
        })
        
    }

    
    //MARK: UIButton action methods
    @IBAction func proceedBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "NavToCOIVc", sender: nil)
        }
    }
    
    // Share Quote form with popover view presented
    @IBAction func shareBtnTapped() {
        if let pdf = Bundle.main.url(forResource: "Binder", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let urlArray = [pdf]
            let activityController = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self.btnShare
            self.present(activityController, animated: true, completion: nil)
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
