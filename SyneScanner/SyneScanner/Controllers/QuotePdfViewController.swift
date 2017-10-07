//
//  QuotePdfViewController.swift
//  SyneScanner
//
//  Created by Markel on 29/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD
class QuotePdfViewController: BaseViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var proceedBtn: UIButton!
    @IBOutlet var centerView: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet var lblCompanyName: UILabel!

    var payOptionsVC : PaymentOptionViewController?
    var companyDetails:[String:String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        payOptionsVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentOptionViewController") as! PaymentOptionViewController
        lblCompanyName.text =  companyDetails?["companyName"]
       
        proceedBtn.setBorderToButton()
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
        if let pdf = Bundle.main.url(forResource: "Quote", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
    }
    //MARK: UIButton action methods
    
    @IBAction func proceedBtnTapped(_ sender: Any) {
//        SVProgressHUD.show()
//        SVProgressHUD.dismiss(withDelay: 1) {
//            self.performSegue(withIdentifier: "NavToPayment", sender: nil)
//        }
        UIView.animate(withDuration: 0.1,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.view.addSubview((self.payOptionsVC?.view)!)
                        self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            self.payOptionsVC?.companyDetails = self.companyDetails
        })
        
    }
    @IBAction   func backBtnClicked()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtnTapped()
    {
        if let pdf = Bundle.main.url(forResource: "Quote", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let urlArray = [pdf]
            let activityController = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self.btnShare
            self.present(activityController, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "NavToPayment"
        {
            let vc:AddCardViewController = segue.destination as! AddCardViewController
            vc.companyDetails = self.companyDetails
        }
    }
    

}
