//
//  InsuranceQuoteViewController.swift
//  SyneScanner
//
//  Created by Markel on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD

class InsuranceQuoteViewController: BaseViewController {



    @IBOutlet var webView: UIWebView!
    @IBOutlet var centerView: UIView!

    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var acceptBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var bottomConstraintBackBtn: NSLayoutConstraint!
    var indexPathArr:[IndexPath] = [IndexPath]()
    var isAnimationShow = false
    var isAnimationShowTbl = false

    var companyList = [["companyName": "Company 1", "price": "3500"],["companyName": "Company 2", "price": "3200"],["companyName": "Company 3", "price": "3000"],["companyName": "Company 4", "price": "2800"],["companyName": "Company 5", "price": "2500"],["companyName": "Company 6", "price": "2500"],["companyName": "Company 7", "price": "2000"],["companyName": "Company 8", "price": "2000"]]
    

    override func viewDidLoad() {
        super.viewDidLoad()
       acceptBtn.setBorderToButton()
        tableView.alpha = 0.0
        self.bottomConstraintBackBtn.constant = -50
        tableView.tableFooterView = UIView()
        
        for i in 0...8
        {
            let indexPath:IndexPath = IndexPath(item: i, section: 0)
            indexPathArr.append(indexPath)
        }
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
        startAnimation()
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
        if isAnimationShow == true {
            return
        }
        isAnimationShow = true
        leftCurveLeading.constant = -10
        rightaCureveTrailing.constant = -16
        self.bottomConstraintBackBtn.constant = 0
        UIView.animate(withDuration: 1.2, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
        }, completion: { finish in
            self.tableView.layoutIfNeeded()
             self.tableView.alpha = 1
            self.isAnimationShowTbl =  true
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.5)
            self.tableView.beginUpdates()
            CATransaction.setCompletionBlock {
                // Code to be executed upon completion
            }
            self.tableView.insertRows(at: self.indexPathArr, with: .top)
            self.tableView.endUpdates()
            CATransaction.commit()
//            self.tableView.reloadData()
//            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
//                self.tableView.alpha = 1
//            }, completion:  { finish in
//            })
        })
        
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
            let vc:QuoteFormViewController = segue.destination as! QuoteFormViewController
            let indexPath:IndexPath = sender as! IndexPath
            vc.companyDetails = companyList[indexPath.row - 1]
        }
    }
    

}
extension InsuranceQuoteViewController:UITableViewDataSource,UITableViewDelegate
{
    
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
       {
        if isAnimationShowTbl
        {
        return companyList.count + 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       

        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath )
            let mainView:UIView = cell.viewWithTag(4)!
            mainView.layer.cornerRadius = 8

            return cell

        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath )
            let dict = companyList[indexPath.row - 1]
            let lblCompanyName:UILabel = cell.viewWithTag(1) as! UILabel
            lblCompanyName.text = dict["companyName"]
            
            let lblPrice:UILabel = cell.viewWithTag(2) as! UILabel
            lblPrice.text = "$" + " " + dict["price"]! + "/y"

            let mainView:UIView = cell.viewWithTag(4)!
            mainView.layer.cornerRadius = 8
            mainView.layer.borderColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1).cgColor
            mainView.layer.borderWidth = 1

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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.10
        cell.layer.shadowRadius = 4

    }
        
//        //1. Setup the CATransform3D structure
//        var rotation: CATransform3D
//        rotation = CATransform3DMakeRotation( CGFloat((90.0 * .pi)/180), 0.0, 0.7, 0.4)
//        rotation.m34 = (1.0 / (-600))
//        
//        
//        //2. Define the initial state (Before the animation)
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
//        cell.alpha = 0;
//        
//        cell.layer.transform = rotation;
//        cell.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
//        
//        
//        
//        //3. Define the final state (After the animation) and commit the animation
//        UIView.beginAnimations("rotation", context: nil)
//        UIView.setAnimationDuration(3.0)
//        cell.layer.transform = CATransform3DIdentity;
//        cell.alpha = 1;
//        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//        UIView.commitAnimations()
//    }
    
}
