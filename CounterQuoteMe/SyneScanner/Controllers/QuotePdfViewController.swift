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
    // MARK: - Properties
    @IBOutlet var webView: UIWebView!
    @IBOutlet var proceedBtn: UIButton!
    @IBOutlet var centerView: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet var lblCompanyName: UILabel!
    var companyDetails:[String:String]?
    
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureUI()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Method that will configure UI intializations
     */
    // MARK: - Configure UI
    func configureUI() {
        lblCompanyName.text =  companyDetails?["companyName"]
        
        proceedBtn.setBorderToButton()
        centerView.layer.cornerRadius = 10
        centerView.layer.masksToBounds = true
        loadPdfFile()
    }
    
    /**
     * Method that will load the PDF file
     */
    func loadPdfFile() {
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
    
    
    @IBAction func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Share Quote form with popover view presented
    @IBAction func shareBtnTapped() {
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
