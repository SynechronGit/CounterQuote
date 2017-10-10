//
//  COIViewController.swift
//  SyneScanner
//
//  Created by Markel on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD
class COIViewController: BaseViewController {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var completeBtn: UIButton!
    @IBOutlet var centerView: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var bottomConstraintcompleteBtn: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = "Certificate Of Insurance"
        
       self.bottomConstraintcompleteBtn.constant = -47
      self.centerView.alpha = 0
        completeBtn.setBorderToButton()
        centerView.layer.cornerRadius = 10
        centerView.layer.masksToBounds = true

        loadPdfFile()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func startAnimation()
    {
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

    func loadPdfFile()
    {
        if let pdf = Bundle.main.url(forResource: "COI", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
    }

    //MARK: UIButton action methods
    
    @IBAction func startNewQuoteBtnTapped(_ sender: Any) {
        SharedData.sharedInstance.arrImage.removeAll()
        let vc = self.navigationController?.viewControllers[2]
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    @IBAction func completeBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "NavToThankUVc", sender: nil)
        }

    }
    @IBAction func shareBtnTapped()
    {
        if let pdf = Bundle.main.url(forResource: "COI", withExtension: "pdf", subdirectory: nil, localization: nil)  {
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
