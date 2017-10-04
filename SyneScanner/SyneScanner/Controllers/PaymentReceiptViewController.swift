//
//  PaymentReceiptViewController.swift
//  SyneScanner
//
//  Created by Kartik on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD

class PaymentReceiptViewController: UIViewController {
    var cardDetailsArray = [String]()
    var cardHeaderArray = [String]()
    var companyDetails:[String:String]?

    @IBOutlet var proceedButton: UIButton!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        proceedButton.layer.borderWidth = 1
        proceedButton.layer.cornerRadius = 22
        proceedButton.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        
        self.title = "Payment Receipt"
        self.navigationItem.setHidesBackButton(true, animated: false)
        cardHeaderArray = ["Insurance company","Policy number",  "Policy Start Date", "Policy End Date","Premium amount"]
        let companyName = companyDetails?["companyName"]
        let price = "$" + (companyDetails?["price"])! + "/y"
        cardDetailsArray = [companyName!,"CCP9871618",  "07/01/2017", "07/01/2018",price]
        tableView.layer.cornerRadius = 16

       // cardDetailsArray.append("$423.00")
       // cardDetailsArray.append("44732456-01")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func proccedBtnTapped ()
    {
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
extension PaymentReceiptViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "receiptCell") as! PaymentReceiptTableViewCell
        cell.headerLabel.text = cardHeaderArray[indexPath.row]
        cell.descriptionLabel.text = cardDetailsArray[indexPath.row]
        return cell
    }
}
