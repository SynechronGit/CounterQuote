//
//  PaymentReceiptViewController.swift
//  SyneScanner
//
//  Created by Kartik on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class PaymentReceiptViewController: UIViewController {
    var cardDetailsArray = [String]()
    var cardHeaderArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment Receipt"
        self.navigationItem.setHidesBackButton(true, animated: false)
        cardHeaderArray = ["Card number", "Cardholder name", "Email Address", "Premium amount", "Transaction ID#"]
        cardDetailsArray.append("$423.00")
        cardDetailsArray.append("44732456-01")
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
