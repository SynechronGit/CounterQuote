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
    var cardDetailsArray = [String]()
    var cardHeaderArray = [String]()
    var companyDetails:[String:String]?

    @IBOutlet var proceedButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imgViewSucces: UIImageView!
    @IBOutlet var lblSuccess: UILabel!
    @IBOutlet weak var bottomConstraintProceedBtn: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.bottomConstraintProceedBtn.constant = -47
        self.tableView.alpha = 0
        self.imgViewSucces.alpha = 0
        self.lblSuccess.alpha = 0
        
        tableView.layer.masksToBounds = false
        tableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.10
        tableView.layer.shadowRadius = 4

     proceedButton.setBorderToButton()
        self.title = "Payment Receipt"
        self.navigationItem.setHidesBackButton(true, animated: false)
        cardHeaderArray = ["Insurance company","Policy number",  "Policy Start Date", "Policy End Date","Premium amount"]
        let companyName = companyDetails?["companyName"]
        let price = "$" + (companyDetails?["price"])! + "/y"
        cardDetailsArray = [companyName!,"CCP9871618",  "07/01/2017", "07/01/2018",price]

       // cardDetailsArray.append("$423.00")
       // cardDetailsArray.append("44732456-01")
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }
    func startAnimation()
    {
      
        
        leftCurveLeading.constant = -10
        rightaCureveTrailing.constant = -16

        self.bottomConstraintProceedBtn.constant = 20
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
        let cornerRadius: CGFloat = 12
        cell.backgroundColor = .clear
        
        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = cell.bounds.insetBy(dx: 20, dy: 0)
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.minY), tangent2End: .init(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.minY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.maxY))
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.maxY), tangent2End: .init(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.maxY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.addRect(bounds)
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
