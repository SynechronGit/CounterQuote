//
//  InsuranceQuoteViewController.swift
//  SyneScanner
//
//  Created by Markel on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD

class InsuranceQuoteViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var centerView: UIView!

    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var acceptBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        acceptBtn.layer.borderWidth = 1
        acceptBtn.layer.cornerRadius = 22
        acceptBtn.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        
        centerView.layer.cornerRadius = 10
        centerView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPdfFile()

    }
    func loadPdfFile()
    {
        if let pdf = Bundle.main.url(forResource: "Quote", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
    }

    func startAnimation()
    {
        
    }
    //MARK: UIButton action methods
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 2) {
            self.performSegue(withIdentifier: "navToPaymentScreen", sender: nil)
        }

    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
