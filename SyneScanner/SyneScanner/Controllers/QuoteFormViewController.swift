//
//  QuoteFormViewController.swift
//  SyneScanner
//
//  Created by Markel on 06/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD

class QuoteFormViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet weak var tableForm: UITableView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var lblActilaPrice: UILabel!
    @IBOutlet weak var lblSavedaAmount: UILabel!
    @IBOutlet weak var imgCompanyLogo: UIImageView!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var bottomConstraintBackBtn: NSLayoutConstraint!

    var isAnimationShow = false
    var agentCallVc:AgentCallViewController?
    var termsnQVc:TermsnConditionViewController?
    var dataArr:NSArray?
    var companyDetails:[String:String]?

    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }
    
    /**
     * Method that will configure UI initializations
     */
    // MARK: - Configure UI
    func configureUI() {
        imgCompanyLogo.image = UIImage(named: (companyDetails?["imgName"])!)

        self.bottomConstraintBackBtn.constant = -80
        self.tableForm.alpha = 0
        self.tableForm.layer.masksToBounds = true

        lblCompanyName.text =  companyDetails?["companyName"]
        
        proceedBtn.setBorderToButton()
        loadDataFromPlist()

        let actualPriceStr:String = (companyDetails?["price"])!
        lblActilaPrice.text = "$" + " " + actualPriceStr + "/y"
        let actualPrice:Int = Int(actualPriceStr)!
        let savedPrice = 4000 - actualPrice
        lblSavedaAmount.text = String(format:"You Saved $ %d",savedPrice)
        viewAmount.layer.cornerRadius = 8
    }
    
    /**
     * Method that will load the plist containing the quote properties
     */
    func loadDataFromPlist() {
        let path = Bundle.main.path(forResource: "QuoteFormData", ofType: "plist")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
        dataArr = plist as? NSArray
    }
    
    /**
     * Method that will start view animations
     */
    //MARK: - Start animation
    func startAnimation() {
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
            self.tableForm.layoutIfNeeded()
            self.tableForm.reloadData()
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
                self.tableForm.alpha = 1
            }, completion:  { finish in
            })
        })
        
    }
    
    
    //MARK: UIButton action methods
    @IBAction func proceedBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "NavToPayment", sender: nil)
        }
    }
    
    
    @IBAction   func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction   func callBtnClicked() {
        // Create the AlertController and add its action like button in Actionsheet
        // Added 2 buttons for call and 1 cancel button
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)

        let saveActionButton = UIAlertAction(title: "Agent Call Me", style: .default)
        { _ in
            self.showCallUsView()
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Call Now", style: .default)
        { _ in
            self.callOnNumber()
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)

        let cancelActionButton = UIAlertAction(title: "Cancel", style: .destructive) { _ in
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    // Share Quote form with popover view presented
    @IBAction func shareBtnTapped(_ sender: Any) {
        if let pdf = Bundle.main.url(forResource: "Quote", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let urlArray = [pdf]
            let btn:UIButton = sender as! UIButton
            let activityController = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = btn
            self.present(activityController, animated: true, completion: nil)
            
        }
    }
    
    // Show terms and conditions on a custom alert screen
    @IBAction func termsNConditionBtnTapped() {
        termsnQVc = self.storyboard?.instantiateViewController(withIdentifier: "termsnQVc") as? TermsnConditionViewController
        termsnQVc?.delegate = self
        self.view.addSubview((termsnQVc?.view)!)
        
        UIView.animate(withDuration: 0.8, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.termsnQVc?.view.frame = self.view.frame
        }, completion: { finish in
            
        })
    }
    
    //MARK: - Agent call methods
    //Call on an agent number
    func callOnNumber() {
        if let url = URL(string: "tel://\("+91999999999")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //Call us view with fileds name and phone to be added
    func showCallUsView() {
        let dict:NSDictionary = dataArr?.object(at: 0) as! NSDictionary
        let arr:NSArray = dict.value(forKey: "data") as! NSArray
        let data:NSDictionary = arr.object(at: 1) as! NSDictionary
        
        agentCallVc = self.storyboard?.instantiateViewController(withIdentifier: "agentCallVc") as? AgentCallViewController
        agentCallVc?.delegate = self
        agentCallVc?.nameText = (data.value(forKey: "value") as? String)!
        agentCallVc?.phoneText = "+91999999999"
        self.view.addSubview((agentCallVc?.view)!)
        
        UIView.animate(withDuration: 0.8, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.agentCallVc?.view.frame = self.view.frame
        }, completion: { finish in
            
            })
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NavToPayment"
        {
            let vc:PaymentOptionViewController = segue.destination as! PaymentOptionViewController
            vc.companyDetails = self.companyDetails
        }
    }
    

}

//MARK: - UItableView datasource and delegate methods
extension QuoteFormViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (dataArr?.count)!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dict:NSDictionary = dataArr?.object(at: section ) as! NSDictionary
        let arr:NSArray = dict.value(forKey: "data") as! NSArray
        return arr.count
    }

   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell:QuoteFromSectionHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell")! as! QuoteFromSectionHeaderTableViewCell
        let dict:NSDictionary = dataArr?.object(at: section ) as! NSDictionary
        cell.headerLabel.text = dict.value(forKey: "title") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QuoteFormTableViewCell = tableView.dequeueReusableCell(withIdentifier: "formCell", for: indexPath ) as! QuoteFormTableViewCell
        let dict:NSDictionary = dataArr?.object(at: indexPath.section) as! NSDictionary
        let arr:NSArray = dict.value(forKey: "data") as! NSArray
        let data:NSDictionary = arr.object(at: indexPath.row) as! NSDictionary
        cell.headerLabel.text =  data.value(forKey: "heading") as? String
        cell.descriptionLabel.text =  data.value(forKey: "value") as? String
        
        if indexPath.row == arr.count - 1
        {
            cell.cellDividerImage.isHidden =  true
        }
        else{
            cell.cellDividerImage.isHidden =  false

        }
        
        return cell
    
   }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          cell.setBorderTocell(indexPath: indexPath, tableView: tableView)
    }
   
}

//MARK: - AgentCallViewControllerDelegate delegate methods
extension QuoteFormViewController:AgentCallViewControllerDelegate
{
    func dismissCallUsView() {
        agentCallVc?.view.removeFromSuperview()
        agentCallVc = nil
    }
}

//MARK: - TermsnConditionViewControllerDelegate delegate methods
extension QuoteFormViewController:TermsnConditionViewControllerDelegate
{
    func dismissTnQView() {
        termsnQVc?.view.removeFromSuperview()
        termsnQVc = nil
    }
}

