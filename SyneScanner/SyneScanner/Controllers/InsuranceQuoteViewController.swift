//
//  InsuranceQuoteViewController.swift
//  SyneScanner
//
//  Created by Markel on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD

class InsuranceQuoteViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var centerView: UIView!

    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var acceptBtn: UIButton!
    @IBOutlet var tableView: UITableView!

    var companyList = [["companyName": "Company 1", "price": "3500"],["companyName": "Company 2", "price": "3200"],["companyName": "Company 3", "price": "3000"],["companyName": "Company 4", "price": "2800"],["companyName": "Company 5", "price": "2500"]]


    override func viewDidLoad() {
        super.viewDidLoad()
        acceptBtn.layer.borderWidth = 1
        acceptBtn.layer.cornerRadius = 22
        acceptBtn.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        tableView.tableFooterView = UIView()
     //   centerView.layer.cornerRadius = 10
      //  centerView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  loadPdfFile()

    }
    func loadPdfFile()
    {
        if let pdf = Bundle.main.url(forResource: "Quote", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
    }

    func startAnimation()
    {
        
    }
    //MARK: UIButton action methods
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "navToPaymentScreen", sender: nil)
        }

    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        let vc = self.navigationController?.viewControllers[3]
        self.navigationController?.popToViewController(vc!, animated: true)
    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NavToQuote"
        {
            let vc:QuotePdfViewController = segue.destination as! QuotePdfViewController
            let indexPath:IndexPath = sender as! IndexPath
            vc.companyDetails = companyList[indexPath.row - 1]
        }
    }
    

}
extension InsuranceQuoteViewController:UITableViewDataSource,UITableViewDelegate
{
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
       {
        return companyList.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath )

            return cell

        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath )
            let dict = companyList[indexPath.row - 1]
            let lblCompanyName:UILabel = cell.viewWithTag(1) as! UILabel
            lblCompanyName.text = dict["companyName"]
            
            let lblPrice:UILabel = cell.viewWithTag(2) as! UILabel
            lblPrice.text = "$" + dict["price"]! + "/y"

            return cell

        }
           }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row != 0
        {
            self.performSegue(withIdentifier: "NavToQuote", sender:indexPath )
  
        }
    }
    
}
