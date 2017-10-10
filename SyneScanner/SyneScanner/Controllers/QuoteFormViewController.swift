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

    @IBOutlet weak var tableForm: UITableView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var lblActilaPrice: UILabel!
    @IBOutlet weak var lblSavedaAmount: UILabel!
    @IBOutlet weak var viewAmount: UIView!

    var isAnimationShow = false

    var agentCallVc:AgentCallViewController?
    var termsnQVc:TermsnConditionViewController?

    var dataArr:NSArray?
    var companyDetails:[String:String]?
    @IBOutlet weak var bottomConstraintBackBtn: NSLayoutConstraint!

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
    
    func configureUI()
    {
        self.bottomConstraintBackBtn.constant = -80
        self.tableForm.alpha = 0
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
            self.tableForm.layoutIfNeeded()
            self.tableForm.reloadData()
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
                self.tableForm.alpha = 1
            }, completion:  { finish in
            })
        })
        
    }
    

    func loadDataFromPlist()
    {
        let path = Bundle.main.path(forResource: "QuoteFormData", ofType: "plist")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
         dataArr = plist as? NSArray
    }
    @IBAction func proceedBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "NavToPayment", sender: nil)
        }
    }
    @IBAction   func backBtnClicked()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction   func callBtnClicked()
    {
        //Create the AlertController and add Its action like button in Actionsheet
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
    @IBAction func shareBtnTapped(_ sender: Any)
    {
        if let pdf = Bundle.main.url(forResource: "Quote", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let urlArray = [pdf]
            let btn:UIButton = sender as! UIButton
            let activityController = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = btn
            self.present(activityController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction   func termsNConditionBtnTapped()
    {
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
    func callOnNumber()
    {
        if let url = URL(string: "tel://\("+91999999999")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

    }
    
    func showCallUsView()
    {
        agentCallVc = self.storyboard?.instantiateViewController(withIdentifier: "agentCallVc") as? AgentCallViewController
        agentCallVc?.delegate = self
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

extension QuoteFormViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return (dataArr?.count)!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        let dict:NSDictionary = dataArr?.object(at: section ) as! NSDictionary
        let arr:NSArray = dict.value(forKey: "data") as! NSArray
        return arr.count
    }

   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
      
        let cell:QuoteFromSectionHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell")! as! QuoteFromSectionHeaderTableViewCell
        let dict:NSDictionary = dataArr?.object(at: section ) as! NSDictionary
        cell.headerLabel.text = dict.value(forKey: "title") as? String
     
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
       
        return 48
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return 68
     
    }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
 
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
       
        let cornerRadius: CGFloat = 12
        cell.backgroundColor = .clear
        
        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = cell.bounds.insetBy(dx: 20, dy: 0)
        // var addLine = false
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.minY), tangent2End: .init(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.minY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.maxY))
            //    addLine = true
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.maxY), tangent2End: .init(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.maxY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.addRect(bounds)
            //  addLine = true
        }
        
        layer.path = pathRef
        layer.fillColor = UIColor(white: 1, alpha: 1).cgColor
        
        //        if (addLine == true) {
        //            let lineLayer = CALayer()
        //            let lineHeight = 1.0 / UIScreen.main.scale
        //            lineLayer.frame = CGRect(x: bounds.minX + 10, y: bounds.size.height - lineHeight, width: bounds.size.width - 10, height: lineHeight)
        //            lineLayer.backgroundColor = tableView.separatorColor?.cgColor
        //            layer.addSublayer(lineLayer)
        //        }
        
        let testView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = .clear
        cell.backgroundView = testView
          
        
    }
   

}
extension QuoteFormViewController:AgentCallViewControllerDelegate
{
    func dismissCallUsView() {
        agentCallVc?.view.removeFromSuperview()
        agentCallVc = nil
    }
}
extension QuoteFormViewController:TermsnConditionViewControllerDelegate
{
    func dismissTnQView() {
        
   
        termsnQVc?.view.removeFromSuperview()
        termsnQVc = nil
    }
}

