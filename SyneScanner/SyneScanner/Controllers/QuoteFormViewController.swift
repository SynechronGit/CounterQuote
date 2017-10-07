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
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    var agentCallVc:AgentCallViewController?
    var dataArr:NSArray?
    var companyDetails:[String:String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblCompanyName.text =  companyDetails?["companyName"]
       
        proceedBtn.setBorderToButton()
        btnShare.setBorderToButton()
        btnCall.setBorderToButton()
        loadDataFromPlist()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .destructive) { _ in
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
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
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    @IBAction func shareBtnTapped()
    {
        if let pdf = Bundle.main.url(forResource: "Quote", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let urlArray = [pdf]
            let activityController = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self.btnShare
            self.present(activityController, animated: true, completion: nil)
            
        }
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
        self.agentCallVc?.view.frame = self.view.frame
        self.view.addSubview((agentCallVc?.view)!)

        
//        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: [], animations: ({
//            // do stuff
//            self.agentCallVc?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//            
//        }), completion: nil)
//        let identityAnimation = CGAffineTransform.identity
//        let scaleOfIdentity = identityAnimation.scaledBy(x: 0.001, y: 0.001)
//        agentCallVc?.view.transform = scaleOfIdentity
//        UIView.animate(withDuration: 0.3/1.5, animations: {
//            let scaleOfIdentity = identityAnimation.scaledBy(x: 1.1, y: 1.1)
//            self.agentCallVc?.view.transform = scaleOfIdentity
//        }, completion: {finished in
//            UIView.animate(withDuration: 0.3/2, animations: {
//                let scaleOfIdentity = identityAnimation.scaledBy(x: 0.9, y: 0.9)
//                self.agentCallVc?.view.transform = scaleOfIdentity
//            }, completion: {finished in
//                UIView.animate(withDuration: 0.3/2, animations: {
//                    self.agentCallVc?.view.transform = identityAnimation
//                    self.agentCallVc?.view.frame = self.view.frame
//
//                }, completion: {finished in
//                    
//                })
//            })
//        })    
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
        return (dataArr?.count)! + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
            
        }
        let dict:NSDictionary = dataArr?.object(at: section - 1) as! NSDictionary
        let arr:NSArray = dict.value(forKey: "data") as! NSArray
        return arr.count
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
//    {
//        if section == 0
//        {
//            return ""
//        }
//        let dict:NSDictionary = dataArr?.object(at: section - 1) as! NSDictionary
//        return dict.value(forKey: "title") as? String
// 
//    }
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0
        {
            return nil
        }
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell")!
        let dict:NSDictionary = dataArr?.object(at: section - 1) as! NSDictionary
        let lbl1:UILabel = cell.viewWithTag(1)! as! UILabel
        lbl1.text = dict.value(forKey: "title") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        return 68
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0
//        {
//            return 68
//        }
//        else
//        {
            return 68
       // }
    }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    if indexPath.section == 0
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath )
        let actualPriceStr:String = (companyDetails?["price"])!
        let lbl1:UILabel = cell.viewWithTag(1)! as! UILabel

        lbl1.text = "$" + " " + actualPriceStr + "/y"
        let actualPrice:Int = Int(actualPriceStr)!
        let savedPrice = 4000 - actualPrice
        
        let lbl2:UILabel = cell.viewWithTag(2)! as! UILabel

        lbl2.text = String(format:"You Saved $ %d",savedPrice)
        

        let mainView:UIView = cell.viewWithTag(4)!

        mainView.layer.cornerRadius = 8

        return cell

    }
    else{
        let cell:QuoteFormTableViewCell = tableView.dequeueReusableCell(withIdentifier: "formCell", for: indexPath ) as! QuoteFormTableViewCell
        let dict:NSDictionary = dataArr?.object(at: indexPath.section - 1) as! NSDictionary
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
   }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != 0
        {
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
   

}
extension QuoteFormViewController:AgentCallViewControllerDelegate
{
    func dismissCallUsView() {
        agentCallVc?.view.removeFromSuperview()
        agentCallVc = nil
    }
}
