//
//  AddCardViewController.swift
//  SyneScanner
//
//  Created by Kartik on 26/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD
class AddCardViewController: UIViewController {
    var cardHeaderArray = [String]()
    let pickerArray = ["Mastercard", "Visa", "Discover", "American Express"]
    var pickerYearArray = [Int]()
    var pickerMonthArray = [String]()
    var indexPath: IndexPath?
    var cardTypeText: String?
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    var month: String?
    var year: String?
    var cardNumber: String?
    var cvv: String = "123"

    var userName = "Christopher Voglund"
    var emailId = "chris68@mail.com"

    var companyDetails:[String:String]?

    @IBOutlet weak var lblSaveedAmount: UILabel!
    @IBOutlet weak var lblPolicyPrice: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var makePaymentButton: UIButton!
    @IBOutlet weak var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Create back button of type custom
        tableView.tableFooterView = UIView()
         CardIOUtilities.preload()
        self.defaultValues()
        headerView.layer.cornerRadius = 8

        let actualPriceStr:String = (companyDetails?["price"])!

        lblPolicyPrice.text = "$" + actualPriceStr + "/y"
        let actualPrice:Int = Int(actualPriceStr)!
        let savedPrice = 4000 - actualPrice
        
        lblSaveedAmount.text = String(format:"You Saved $%d",savedPrice)
        makePaymentButton.layer.borderWidth = 1
        makePaymentButton.layer.cornerRadius = 22
        makePaymentButton.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        
        
        self.makePaymentButton.isEnabled = true
        self.commonSetup()
        self.title  = "Payment Method"
        tableView.layer.cornerRadius = 16
       // tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 @IBAction   func popToRoot()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func defaultValues() {
        month = "09"
        year = "17"
        cardNumber = "4111 1111 1111 1111"
    }
    
    @IBAction func buyTapped(_ sender: Any) {
        var cardDetailsArray : [String] = [String]()
        for item in 0...cardHeaderArray.count {
            let indexPath = IndexPath(row: item, section: 0)
            let cell : AddCardTableViewCell? = self.tableView.cellForRow(at: indexPath) as! AddCardTableViewCell?
            if let details = cell?.descriptionField.text {
                cardDetailsArray.append(details)
                }
            }
        
        if (cardDetailsArray.contains(where: { $0 == "" })) {
            let message = "Please fill all card details!"
            self.showAlert(message: message)
        }
        else if(!isValidEmail(testStr: emailId)) {
            let message = "Invalid Email Address!"
            self.showAlert(message: message)
        } else {
            
            SVProgressHUD.show()
            SVProgressHUD.dismiss(withDelay: 1) {
                let paymentReceiptVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentReceiptViewController") as! PaymentReceiptViewController
                for item in 0...1 {
                    paymentReceiptVC.cardDetailsArray.append(cardDetailsArray[item])
                }
                paymentReceiptVC.cardDetailsArray.append(self.emailId)
                paymentReceiptVC.companyDetails = self.companyDetails
                self.navigationController?.pushViewController(paymentReceiptVC, animated: true)
            }
           
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func commonSetup() {
        cardHeaderArray = ["Card Number", "Card Holder name", "Expiry date", "CVV"]
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...15 {
                years.append(year)
                year += 1
            }
        }
        pickerYearArray = years
        
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        pickerMonthArray = months
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}

//MARK: UITableViewDataSource delegate methods
extension AddCardViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1
        {
            return 1

        }
        
        return cardHeaderArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! AddCardTableViewCell
        cell.descriptionField.placeholder = cardHeaderArray[indexPath.row]
        cell.descriptionField.tag = indexPath.row
        cell.descriptionField.isSecureTextEntry =  false
        cell.actionDelegate = self
        if indexPath.section == 0
        {
            switch indexPath.row {
            case 0:
                cell.descriptionField.rightViewMode = UITextFieldViewMode.always
                //            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                //            imageView.contentMode = .scaleAspectFit
                //            let image = UIImage(named: pickerArray.first!)
                //            imageView.image = image
                //            cell.descriptionField.rightView = imageView
                cell.descriptionField.text = cardNumber
                cell.descriptionField.keyboardType = .numberPad

                cell.cardScanBtn.isHidden = false
            case 1:
                cell.descriptionField.keyboardType = .alphabet
                cell.cardScanBtn.isHidden = true
                cell.descriptionField.text = userName
                
            case 2:
                cell.descriptionField.text = month?.appendingFormat("/%@", year!)
                cell.cardScanBtn.isHidden = true
                
            case 3:
                cell.descriptionField.text = cvv
                cell.descriptionField.keyboardType = .numberPad
                cell.descriptionField.isSecureTextEntry =  true

                cell.cardScanBtn.isHidden = true
                
            default:
                cell.descriptionField.keyboardType = .default
                cell.cardScanBtn.isHidden = true
                
                break
            }
 
        }
        else{
            cell.descriptionField.text = emailId
            cell.descriptionField.keyboardType = .emailAddress
            cell.cardScanBtn.isHidden = true
 
        }
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude
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

//MARK: RightArrow action delegate methods
extension AddCardViewController: TextFieldActionDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func textFieldTappedAt(cell: AddCardTableViewCell) {
        indexPath = self.tableView.indexPath(for: cell)
        if indexPath?.row == 2 && indexPath?.section == 0 {
            let picker = UIPickerView()
            picker.showsSelectionIndicator = true
            picker.delegate = self
            picker.dataSource = self
            cell.descriptionField.addDoneOnKeyboardWithTarget(self, action: #selector(doneSecureAction))
            cell.descriptionField.inputView = picker
        }
    }
    
    func doneSecureAction(button: UIBarButtonItem) {
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath!)
        self.tableView.reloadRows(at: indexPaths, with: .top)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: 44))
        let myLabel = UILabel(frame: CGRect(x: myView.frame.size.width/4 + 10, y: 0, width: pickerView.bounds.width - 100, height: myView.bounds.height))
        switch component {
        case 0:
            month = "01"
            myLabel.text = pickerMonthArray[row]
        case 1:
            let yearString = (String(pickerYearArray.first!))
            let index = yearString.index(yearString.startIndex, offsetBy: 2)
            year = yearString.substring(from: index)
            myLabel.text = "\(pickerYearArray[row])"
        default:
            myLabel.text = ""
            break
        }
        myView.addSubview(myLabel)
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return pickerMonthArray.count
        case 1:
            return pickerYearArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            if row < 10 {
                month = "0".appending(String(row))
            } else {
                month = String(row)
            }
        case 1:
            year = "\(pickerYearArray[row])"
            let yearString = year
            let index = yearString?.index((yearString?.startIndex)!, offsetBy: 2)
            year = yearString?.substring(from: index!)
        default:
            break
        }
    }
    func showCardScanVc()
    {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
}

extension AddCardViewController:CardIOPaymentViewControllerDelegate
{
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            print(str)
            
            cardNumber = info.redactedCardNumber
            month = String(format:"%d",info.expiryMonth)
            year = String(format:"%d",info.expiryYear)
            cvv = info.cvv
            if let name = info.cardholderName
            {
                userName = name

            }
            
            tableView.reloadData()
            
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
    }

}
