//
//  COIViewController.swift
//  SyneScanner
//
//  Created by Markel on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD
class COIViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var completeBtn: UIButton!
    @IBOutlet var centerView: UIView!
    @IBOutlet weak var btnShare: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = "Certificate Of Insurance"
        
       
        completeBtn.layer.borderWidth = 1
        completeBtn.layer.cornerRadius = 22
        completeBtn.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        centerView.layer.cornerRadius = 10
        centerView.layer.masksToBounds = true

        loadPdfFile()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
