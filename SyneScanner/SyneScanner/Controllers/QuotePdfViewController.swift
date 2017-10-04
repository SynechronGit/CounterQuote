//
//  QuotePdfViewController.swift
//  SyneScanner
//
//  Created by Markel on 29/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD
class QuotePdfViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var proceedBtn: UIButton!
    @IBOutlet var centerView: UIView!
    
    @IBOutlet var lblCompanyName: UILabel!

    var companyDetails:[String:String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCompanyName.text =  companyDetails?["companyName"]
        proceedBtn.layer.borderWidth = 1
        proceedBtn.layer.cornerRadius = 22
        proceedBtn.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        
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
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "NavToPayment", sender: nil)
        }
        
    }
    @IBAction   func backBtnClicked()
    {
        self.navigationController?.popViewController(animated: true)
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