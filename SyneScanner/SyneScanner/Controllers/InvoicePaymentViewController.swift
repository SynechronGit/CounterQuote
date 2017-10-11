//
//  InvoicePaymentViewController.swift
//  SyneScanner
//
//  Created by Kartik on 07/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class InvoicePaymentViewController: BaseViewController {

    // MARK: - Properties
    @IBOutlet weak var lblSaveedAmount: UILabel!
    @IBOutlet weak var lblPolicyPrice: UILabel!
    @IBOutlet weak var headerView: UIView!
    var companyDetails:[String:String]?
    
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        headerView.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
        let actualPriceStr:String = (companyDetails?["price"])!
        lblPolicyPrice.text = "$" + actualPriceStr + "/y"
        let actualPrice:Int = Int(actualPriceStr)!
        let savedPrice = 4000 - actualPrice
        
        lblSaveedAmount.text = String(format:"You Saved $%d",savedPrice)

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
