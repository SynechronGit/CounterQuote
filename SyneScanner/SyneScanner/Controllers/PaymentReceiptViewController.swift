//
//  PaymentReceiptViewController.swift
//  SyneScanner
//
//  Created by Kartik on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD

class PaymentReceiptViewController: BaseViewController {
     // MARK: - Properties
    var cardDetailsArray = [String]()
    var cardHeaderArray = [String]()
    var companyDetails:[String:String]?

    @IBOutlet var proceedButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imgViewSucces: UIImageView!
    @IBOutlet var lblSuccess: UILabel!
    @IBOutlet weak var bottomConstraintProceedBtn: NSLayoutConstraint!

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       configurUI()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    /**
     * Method that will configure UI intializations
     */
   // MARK: - Configure UI
    func configurUI() {
        self.bottomConstraintProceedBtn.constant = -47
        self.tableView.alpha = 0
        self.imgViewSucces.alpha = 0
        self.lblSuccess.alpha = 0
        
        tableView.tableFooterView = UIView()
        tableView.addShadow()
        
        proceedButton.setBorderToButton()
        cardHeaderArray = ["Insurance company","Policy number",  "Policy Start Date", "Policy End Date","Premium amount"]
        let companyName = companyDetails?["companyName"]
        let price = "$" + (companyDetails?["price"])! + "/y"
        cardDetailsArray = [companyName!,"CCP9871618",  "07/01/2017", "07/01/2018",price]
    }
    
    
    /**
     * Method that will start view animations
     */
    func startAnimation() {
        leftCurveLeading.constant = -10
        rightaCureveTrailing.constant = -16
        self.bottomConstraintProceedBtn.constant = 20
        // Animate tableview cells
        UIView.animate(withDuration: 1.2, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
        }, completion: { finish in
            self.tableView.layoutIfNeeded()
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
                self.tableView.alpha = 1
                self.lblSuccess.alpha = 1
                self.imgViewSucces.alpha = 1
            }, completion:  { finish in
            })
        })
        
    }
    
    //MARK: UIButton action methods
    @IBAction func proccedBtnTapped () {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "NavToBinder", sender: nil)
        }
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

//MARK: UITableView DataSource delegate methods
extension PaymentReceiptViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardDetailsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "receiptCell") as! PaymentReceiptTableViewCell
        cell.headerLabel.text = cardHeaderArray[indexPath.row]
        cell.descriptionLabel.text = cardDetailsArray[indexPath.row]
        if indexPath.row == cardDetailsArray.count - 1 {
            cell.cellDividerImage.isHidden = true
        } else {
            cell.cellDividerImage.isHidden = false
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setBorderTocell(indexPath: indexPath, tableView: tableView)

    }

}
