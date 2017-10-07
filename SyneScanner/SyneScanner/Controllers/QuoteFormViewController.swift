//
//  QuoteFormViewController.swift
//  SyneScanner
//
//  Created by Markel on 06/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class QuoteFormViewController: BaseViewController {

    @IBOutlet weak var tableForm: UITableView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    var companyDetails:[String:String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblCompanyName.text =  companyDetails?["companyName"]
       
        proceedBtn.setBorderToButton()
        btnShare.setBorderToButton()
        btnCall.setBorderToButton()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
