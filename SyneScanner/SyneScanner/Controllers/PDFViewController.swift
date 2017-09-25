//
//  PDFViewController.swift
//  SyneScanner
//
//  Created by Markel on 25/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    var fileName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)

        loadPdfFile()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadPdfFile()
    {
        if let pdf = Bundle.main.url(forResource: fileName, withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
    }
    
    //MARK: UIButton action methods
    
    @IBAction func buyBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
