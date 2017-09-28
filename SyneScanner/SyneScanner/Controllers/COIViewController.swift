//
//  COIViewController.swift
//  SyneScanner
//
//  Created by Markel on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class COIViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = "Quote"
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

    //MARK: UIButton action methods
    
    @IBAction func startNewQuoteBtnTapped(_ sender: Any) {
    }
    @IBAction func completeBtnTapped(_ sender: Any) {
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
