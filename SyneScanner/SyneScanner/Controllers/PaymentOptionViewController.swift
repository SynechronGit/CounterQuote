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
    @IBOutlet weak var cardPayScrollView: UIScrollView!
    @IBOutlet weak var invoicePayScrollView: UIScrollView!
    @IBOutlet weak var backBtnView: UIView!
    
    @IBOutlet weak var innerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var invoiceViewHeightConstriant: NSLayoutConstraint!
    var companyDetails:[String:String]?
    var addCardVC : AddCardViewController?
    var invoiceVC : InvoicePaymentViewController?
    var isCardViewShown = false
    var isInvoiceViewShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCardVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCardViewController") as? AddCardViewController
        invoiceVC = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePaymentViewController") as? InvoicePaymentViewController
        self.addChildViewController(addCardVC!)
        
        self.invoicePayScrollView.contentSize = CGSize(width: (self.invoiceVC?.view.frame.size.width)!, height: 200)
        self.cardPayScrollView.contentSize = CGSize(width: (self.addCardVC?.view.frame.size.width)!, height: 568)
        
        isCardViewShown = false
        isInvoiceViewShown = false
        innerViewLeadingConstraint.constant = 20
        innerViewTrailingConstraint.constant = 20
        innerViewHeightConstraint.constant = 140
        invoiceViewHeightConstriant.constant = 70
        cardViewHeightConstraint.constant = 70
        innerView.layoutIfNeeded()
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
    }
    
    //MARK: UIButton action methods
    
    @IBAction func cardPayTapped(_ sender: Any) {
//        SVProgressHUD.show()
//        SVProgressHUD.dismiss(withDelay: 1) {
//            self.performSegue(withIdentifier: "NavToPayment", sender: nil)
//        }
        if isCardViewShown {
            invoiceViewHeightConstriant.constant = 70
            
            UIView.animate(withDuration: 1.5, delay: 0.5,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.8,
                           options: [], animations: {
                            self.innerViewLeadingConstraint.constant = 20
                            self.innerViewTrailingConstraint.constant = 20
                            self.innerViewHeightConstraint.constant = 140
                            self.cardViewHeightConstraint.constant = 70
                            self.invoiceViewHeightConstriant.constant = 70
                            self.addCardVC?.view.removeFromSuperview()
                            self.invoiceVC?.view.removeFromSuperview()
                            self.innerView.layoutIfNeeded()
            }, completion: nil)
            isCardViewShown = false
        } else {
            if isInvoiceViewShown {
                UIView.animate(withDuration: 1.5, delay: 0.5,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.8,
                               options: [], animations: {
                                self.innerViewLeadingConstraint.constant = 20
                                self.innerViewTrailingConstraint.constant = 20
                                self.innerViewHeightConstraint.constant = 140
                                self.invoiceViewHeightConstriant.constant = 70
                                self.cardViewHeightConstraint.constant = 70
                                self.innerView.layoutIfNeeded()
                                self.invoiceVC?.view.removeFromSuperview()
                                self.addCardVC?.view.removeFromSuperview()
                                self.invoicePayScrollView.layoutIfNeeded()
                }, completion: nil)
                isInvoiceViewShown = false
            }
            invoiceViewHeightConstriant.constant = 70
            self.cardPayScrollView.bounds = CGRect.zero
            self.cardPayScrollView.addSubview((self.addCardVC?.view)!)
            self.addCardVC?.view.frame = CGRect(x: 0, y: 0, width: self.cardPayScrollView.frame.size.width, height: 250)
            UIView.animate(withDuration: 1.5, delay: 0.5,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.8,
                           options: [], animations: {
                            self.innerViewLeadingConstraint.constant = 0
                            self.innerViewTrailingConstraint.constant = 0
                            self.innerViewHeightConstraint.constant = UIScreen.main.bounds.height - self.backBtnView.frame.size.height * 2
                            self.innerView.layoutIfNeeded()
                            self.invoiceVC?.view.removeFromSuperview()
                            self.cardViewHeightConstraint.constant = self.innerViewHeightConstraint.constant - self.invoiceViewHeightConstriant.constant
                            self.addCardVC?.companyDetails = self.companyDetails
                            self.addCardVC?.view.layoutIfNeeded()
                            self.cardPayScrollView.layoutIfNeeded()
                            self.innerView.layoutIfNeeded()
            }, completion: nil)
            isCardViewShown = true
        }
    }
    
    @IBAction func invoicePayTapped(_ sender: Any) {
//        SVProgressHUD.show()
//        SVProgressHUD.dismiss(withDelay: 1) {
//            self.performSegue(withIdentifier: "InvoiceToReceipt", sender: nil)
//        }
        if isInvoiceViewShown {
            UIView.animate(withDuration: 1.5, delay: 0.5,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.8,
                           options: [], animations: {
                            self.innerViewLeadingConstraint.constant = 20
                            self.innerViewTrailingConstraint.constant = 20
                            self.innerViewHeightConstraint.constant = 140
                            self.invoiceViewHeightConstriant.constant = 70
                            self.cardViewHeightConstraint.constant = 70
                            self.innerView.layoutIfNeeded()
                            self.invoiceVC?.view.removeFromSuperview()
                            self.addCardVC?.view.removeFromSuperview()
                            self.invoicePayScrollView.layoutIfNeeded()
            }, completion: nil)
            isInvoiceViewShown = false
        } else {
            if isCardViewShown {
                UIView.animate(withDuration: 1.5, delay: 0.5,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.8,
                               options: [], animations: {
                                self.innerViewLeadingConstraint.constant = 20
                                self.innerViewTrailingConstraint.constant = 20
                                self.innerViewHeightConstraint.constant = 140
                                self.cardViewHeightConstraint.constant = 70
                                self.invoiceViewHeightConstriant.constant = 70
                                self.addCardVC?.view.removeFromSuperview()
                                self.invoiceVC?.view.removeFromSuperview()
                                self.innerView.layoutIfNeeded()
                }, completion: nil)
                isCardViewShown = false
            }
            cardViewHeightConstraint.constant = 70
            self.invoiceVC?.view.frame = CGRect(x: 0, y: 0, width: self.invoicePayScrollView.frame.size.width, height: 568)
            self.invoicePayScrollView.addSubview((self.invoiceVC?.view)!)
            UIView.animate(withDuration: 1.5, delay: 0.5,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.8,
                           options: [], animations: {
                            self.innerViewLeadingConstraint.constant = 0
                            self.innerViewTrailingConstraint.constant = 0
                            self.innerViewHeightConstraint.constant = UIScreen.main.bounds.height - self.backBtnView.frame.size.height * 2
                            self.innerView.layoutIfNeeded()
                            self.addCardVC?.view.removeFromSuperview()
                            self.invoiceViewHeightConstriant.constant = self.innerViewHeightConstraint.constant - self.cardViewHeightConstraint.constant
                            self.invoicePayScrollView.layoutIfNeeded()
                            self.innerView.layoutIfNeeded()
            }, completion: nil)
            isInvoiceViewShown = true
        }
    }
    
    @IBAction func popToRoot() {
        self.navigationController?.popViewController(animated: true)
    }

}
