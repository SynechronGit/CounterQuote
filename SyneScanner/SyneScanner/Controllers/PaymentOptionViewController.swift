//
//  PaymentOptionViewController.swift
//  SyneScanner
//
//  Created by Kartik on 06/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD

class PaymentOptionViewController: UIViewController {
    @IBOutlet weak var innerView: UIView!
    @IBOutlet var cardPayButton: UIButton!
    @IBOutlet var invoicePayButton: UIButton!
    
    var companyDetails:[String:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardPayButton.layer.borderWidth = 1
        cardPayButton.layer.cornerRadius = 22
        cardPayButton.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        invoicePayButton.layer.borderWidth = 1
        invoicePayButton.layer.cornerRadius = 22
        invoicePayButton.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        
        innerView.layer.cornerRadius = 12
        innerView.layer.borderWidth = 1
        innerView.layer.borderColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK: UIButton action methods
    
    @IBAction func cardPayTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "NavToPayment", sender: nil)
        }
    }
    
    @IBAction func invoicePayTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "InvoiceToReceipt", sender: nil)
        }
    }

}
