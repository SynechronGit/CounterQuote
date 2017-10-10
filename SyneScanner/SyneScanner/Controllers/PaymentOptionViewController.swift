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
    @IBOutlet weak var invoiceBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var payBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardPayBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var invoicePayTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cardPayBtnView: UIView!
    @IBOutlet weak var invoicePayBtnView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var invoiceView: UIView!
    @IBOutlet var invoicePaymentButton: UIButton!
    @IBOutlet var cardPaymentButton: UIButton!
    
    var cardDetailsArray : [String]?
    var companyDetails:[String:String]?
    var addCardVC : AddCardViewController?
    var invoiceVC : InvoicePaymentViewController?
    var isCardViewShown = false
    var isInvoiceViewShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCardVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCardViewController") as? AddCardViewController
        addCardVC?.cardActionDelegate = self
        invoiceVC = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePaymentViewController") as? InvoicePaymentViewController
        self.addChildViewController(invoiceVC!)
        self.addChildViewController(addCardVC!)
        self.addCardVC?.companyDetails = self.companyDetails
        self.invoicePayScrollView.contentSize = CGSize(width: (self.invoiceVC?.view.frame.size.width)!, height: UIScreen.main.bounds.height)
        self.cardPayScrollView.contentSize = CGSize(width: (self.addCardVC?.view.frame.size.width)!, height: UIScreen.main.bounds.height)
        self.payBtnHeightConstraint.constant = 0
        self.invoiceBtnHeightConstraint.constant = 0
        
        cardPaymentButton.setBorderToButton()
        self.cardPaymentButton.isEnabled = true
        invoicePaymentButton.setBorderToButton()
        self.invoicePaymentButton.isEnabled = true
        
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

        innerView.layer.cornerRadius = 12
        innerView.layer.borderWidth = 1
        innerView.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
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
        self.cardPaymentButton.isHidden = false
            innerView.layer.cornerRadius = 0
            self.cardPayScrollView.bounds = CGRect.zero
            self.addCardVC?.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.cardPayScrollView.frame.size.width, height: UIScreen.main.bounds.height)
            UIView.animate(withDuration: 1.0, delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [], animations: {
                            self.invoiceViewHeightConstriant.constant = 0
                            self.innerViewLeadingConstraint.constant = 0
                            self.innerViewTrailingConstraint.constant = 0
                            self.cardPayBottomConstraint.constant = -80
                            self.innerViewHeightConstraint.constant = UIScreen.main.bounds.height
                            self.cardViewHeightConstraint.constant = self.innerViewHeightConstraint.constant - self.backBtnView.frame.size.height - 20
                            self.payBtnHeightConstraint.constant = 40
                            self.innerView.layoutIfNeeded()
                            
            }) { _ in
                UIView.animate(withDuration: 1.5, delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.5,
                               options: [], animations: {
                                self.addCardVC?.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.origin.y, width: self.cardPayScrollView.frame.size.width, height: UIScreen.main.bounds.height)
                                }, completion: nil)
            }
            self.cardPayButton.isHidden = true
            self.cardPayScrollView.addSubview((self.addCardVC?.view)!)
            isCardViewShown = true
//        }
    }
    
    @IBAction func invoicePayTapped(_ sender: Any) {
            self.invoicePaymentButton.isHidden = false
            innerView.layer.cornerRadius = 0
            self.invoicePayScrollView.bounds = CGRect.zero
            self.invoiceVC?.view.frame = CGRect(x: 0, y: -UIScreen.main.bounds.height, width: self.invoicePayScrollView.frame.size.width, height: UIScreen.main.bounds.height)
            UIView.animate(withDuration: 1.0, delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [], animations: {
                            self.cardViewHeightConstraint.constant = 0
                            self.innerViewLeadingConstraint.constant = 0
                            self.innerViewTrailingConstraint.constant = 0
                            self.invoicePayTopConstraint.constant = -60
                            self.innerViewHeightConstraint.constant = UIScreen.main.bounds.height
                            self.invoiceViewHeightConstriant.constant = self.innerViewHeightConstraint.constant - self.backBtnView.frame.size.height - 30
                            self.invoiceBtnHeightConstraint.constant = 0
                            self.innerView.layoutIfNeeded()
                            
            }) { _ in
                UIView.animate(withDuration: 1.5, delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.5,
                               options: [], animations: {
                                self.invoiceVC?.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.origin.y, width: self.invoicePayScrollView.frame.size.width, height: UIScreen.main.bounds.height)
                }, completion: nil)
            }
            self.invoicePayButton.isHidden = true
            self.invoicePayScrollView.addSubview((self.invoiceVC?.view)!)
            isInvoiceViewShown = true
//        }
    }
    
    @IBAction func popToRoot() {
        innerView.layer.cornerRadius = 12
        if isCardViewShown {
            invoiceViewHeightConstriant.constant = 70
            UIView.animate(withDuration: 1.0, delay: 0.1,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.8,
                           options: [], animations: {
                            self.addCardVC?.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.cardPayScrollView.frame.size.width, height: UIScreen.main.bounds.height)
                            
            }) { _ in
                UIView.animate(withDuration: 1.0, delay: 0.1,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.5,
                               options: [], animations: {
                                self.payBtnHeightConstraint.constant = 0
                                self.cardPayBottomConstraint.constant = 10
                                self.cardViewHeightConstraint.constant = 70
                                self.invoiceViewHeightConstriant.constant = 70
                                self.innerViewHeightConstraint.constant = 140
                                self.innerViewLeadingConstraint.constant = 20
                                self.innerViewTrailingConstraint.constant = 20
                                self.innerView.layoutIfNeeded()
                }, completion: nil)
            }
            self.cardPaymentButton.isHidden = true
            self.cardPayButton.isHidden = false
            self.addCardVC?.view.removeFromSuperview()
            self.invoiceVC?.view.removeFromSuperview()
            isCardViewShown = false

        } else if isInvoiceViewShown {
            UIView.animate(withDuration: 1.0, delay: 0.1,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.8,
                           options: [], animations: {
                            self.invoiceVC?.view.frame = CGRect(x: 0, y: -UIScreen.main.bounds.height, width: self.invoicePayScrollView.frame.size.width, height: UIScreen.main.bounds.height)
            }) { _ in
                UIView.animate(withDuration: 1.0, delay: 0.1,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.5,
                               options: [], animations: {
                                self.invoiceBtnHeightConstraint.constant = 0
                                self.invoicePayTopConstraint.constant = 0
                                self.invoiceViewHeightConstriant.constant = 70
                                self.cardViewHeightConstraint.constant = 70
                                self.innerViewHeightConstraint.constant = 140
                                self.innerViewLeadingConstraint.constant = 20
                                self.innerViewTrailingConstraint.constant = 20
                                self.innerView.layoutIfNeeded()
                }, completion: nil)
            }
            self.invoicePaymentButton.isHidden = true
            self.invoicePayButton.isHidden = false
            self.invoiceVC?.view.removeFromSuperview()
            self.addCardVC?.view.removeFromSuperview()
            isInvoiceViewShown = false

        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func invoiceBuyTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            let paymentReceiptVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentReceiptViewController") as! PaymentReceiptViewController
            for _ in 0...1 {
                paymentReceiptVC.cardDetailsArray.append("4111 1111 1111 1111")
                paymentReceiptVC.cardDetailsArray.append("Christopher Voglund")
            }
            paymentReceiptVC.cardDetailsArray.append("chris68@mail.com")
            paymentReceiptVC.companyDetails = self.companyDetails
            self.navigationController?.pushViewController(paymentReceiptVC, animated: true)
        }
    }
    
    @IBAction func cardBuyTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            let paymentReceiptVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentReceiptViewController") as! PaymentReceiptViewController
            if let cardDetails = self.cardDetailsArray {
                for item in 0...1 {
                    paymentReceiptVC.cardDetailsArray.append(cardDetails[item])
                }
                paymentReceiptVC.cardDetailsArray.append(cardDetails.last!)
            }
            paymentReceiptVC.companyDetails = self.companyDetails
            self.navigationController?.pushViewController(paymentReceiptVC, animated: true)
        }
    }

}

extension PaymentOptionViewController: CardTextFieldFilledDelegate {
    func cardDetailsFilledWith(cardDetailsArray: [String]) {
        self.cardDetailsArray = cardDetailsArray
    }
}
