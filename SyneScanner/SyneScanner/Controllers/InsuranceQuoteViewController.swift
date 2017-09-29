//
//  InsuranceQuoteViewController.swift
//  SyneScanner
//
//  Created by Markel on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class InsuranceQuoteViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var acceptBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 22
        cancelBtn.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        acceptBtn.layer.borderWidth = 1
        acceptBtn.layer.cornerRadius = 22
        acceptBtn.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        loadPdfFile()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadPdfFile()
    {
        if let pdf = Bundle.main.url(forResource: "policy", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
    }

    func startAnimation()
    {
        
    }
    //MARK: UIButton action methods
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "navToPaymentScreen", sender: nil)
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
