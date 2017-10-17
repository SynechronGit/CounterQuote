//
//  AddCardViewController.swift
//  SyneScanner
//
//  Created by Kartik on 26/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddCardViewController: BaseViewController {
    // MARK: - Properties
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
    var cvv: String?
    var userName: String?
    var emailId: String?
    var companyDetails:[String:String]?

    @IBOutlet weak var lblSaveedAmount: UILabel!
    @IBOutlet weak var lblPolicyPrice: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!

     // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(AddCardViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        defaultsChanged()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     * Method that will configure UI intializations
     */
    // MARK: - Configure UI
    func configureUI() {
        CardIOUtilities.preload()
        
        headerView.layer.cornerRadius = 8
        let actualPriceStr:String = (companyDetails?["price"])!
        lblPolicyPrice.text = "$" + actualPriceStr + "/y"
        let actualPrice:Int = Int(actualPriceStr)!
        let savedPrice = 4000 - actualPrice
        lblSaveedAmount.text = String(format:"You Saved $%d",savedPrice)
        
        tableView.addShadow()
        tableView.tableFooterView = UIView()
        
        self.commonSetup()
    }
    
    /**
     * Method that will set default values of card
     */
    func defaultValues() {
        cvv = "123"
        month = "09"
        year = "17"
        cardNumber = "4111 1111 1111 1111"
        userName = "Christopher Voglund"
        emailId = "chris68@mail.com"
    }
    
    /**
     * Method that will set up the number of months and years of a card expiry date along with the card details required from the user
     */
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
    
     func defaultsChanged() {
        if UserDefaults.standard.bool(forKey: "demo_preference") {
            self.defaultValues()
        } else {
            month = ""
            year = ""
            cardNumber = ""
            userName = ""
            emailId = ""
            cvv = ""
        }
    }
    
    //MARK: - Show Alert for Validations
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        if section == 1 {
            return 1
        }
        return cardHeaderArray.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! AddCardTableViewCell
        
        if indexPath.section == 0 {
            cell.descriptionField.tag = indexPath.row
        } else {
            cell.descriptionField.tag = 4
        }
        cell.descriptionField.isSecureTextEntry =  false
        cell.actionDelegate = self
        cell.cellDividerImage.isHidden = false
        if indexPath.section == 0
        {
            var headerString = cardHeaderArray[indexPath.row]
            headerString.append("*")
            let font:UIFont? = cell.descriptionField.font
            let fontSuper:UIFont? = UIFont(name: (font?.fontName)!, size:10)
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: headerString, attributes: [NSFontAttributeName:font!])
            attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:attString.length - 1,length:1))
            cell.descriptionField.attributedPlaceholder = attString
            
            switch indexPath.row {
            case 0:
                cell.descriptionField.rightViewMode = UITextFieldViewMode.always
                cell.descriptionField.text = cardNumber
                cell.descriptionField.keyboardType = .numberPad

                cell.cardScanBtn.isHidden = false
            case 1:
                cell.descriptionField.keyboardType = .alphabet
                cell.cardScanBtn.isHidden = true
                cell.descriptionField.text = userName
                
            case 2:
                if month == "" && year == "" {
                    cell.descriptionField.text = month?.appendingFormat("%@", year!)
                } else {
                    cell.descriptionField.text = month?.appendingFormat("/%@", year!)
                }
                
                cell.cardScanBtn.isHidden = true
                
            case 3:
                cell.descriptionField.text = cvv
                cell.descriptionField.keyboardType = .numberPad
                cell.descriptionField.isSecureTextEntry =  true
                cell.cardScanBtn.isHidden = true
                cell.cellDividerImage.isHidden = true
                
            default:
                cell.descriptionField.keyboardType = .default
                cell.cardScanBtn.isHidden = true
                
                break
            }
        }
        else{
            var headerString = "Email ID"
            headerString.append("*")
            let font:UIFont? = cell.descriptionField.font
            let fontSuper:UIFont? = UIFont(name: (font?.fontName)!, size:8)
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: headerString, attributes: [NSFontAttributeName:font!])
            attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:attString.length - 1,length:1))
            cell.descriptionField.attributedPlaceholder = attString
            
            cell.descriptionField.text = emailId
            cell.descriptionField.keyboardType = .emailAddress
            cell.cardScanBtn.isHidden = true
            cell.cellDividerImage.isHidden = true
        }
        return cell
    }
  
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setBorderTocell(indexPath: indexPath, tableView: tableView)
    }
}


//MARK: TableViewCell textfield delegate methods
extension AddCardViewController: TextFieldActionDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    // Textfield tap to show picker view for year and month of card expiry date
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
    
    // Update card details array after all textfields are filled and returned
    func textFieldsFilledFor(cell: AddCardTableViewCell) {
        var cardDetailsArray : [String] = [String]()
        for item in 0...cardHeaderArray.count {
            let indexPath = IndexPath(row: item, section: 0)
            let cell : AddCardTableViewCell? = self.tableView.cellForRow(at: indexPath) as! AddCardTableViewCell?
            if let details = cell?.descriptionField.text {
                cardDetailsArray.append(details)
            }
        }
        
        let indexPath = IndexPath(row: 0, section: 1)
        let cell: AddCardTableViewCell? = self.tableView.cellForRow(at: indexPath) as! AddCardTableViewCell?
        if let details = cell?.descriptionField.text {
            cardDetailsArray.append(details)
        }
        
        if (cardDetailsArray.contains(where: { $0 == "" })) {
            let message = "Please fill all card details!"
            self.showAlert(message: message)
        }
        else if(!isValidEmail(testStr: emailId!)) {
            let message = "Invalid Email Address!"
            self.showAlert(message: message)
        }
        else {
        }
    }
    
    // Reload all tableview cells with textfield values
    func doneSecureAction(button: UIBarButtonItem) {
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath!)
        self.tableView.reloadRows(at: indexPaths, with: .top)
    }
    
    //MARK: - UIPickerView data source methods
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
    
    //MARK: - UIPickerView delegate methods
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
    
    //MARK: - CardIOPayment card scan method
    func showCardScanVc() {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
}

//MARK: - CardIOPaymentViewControllerDelegate methods
extension AddCardViewController:CardIOPaymentViewControllerDelegate {
    
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
            if let name = info.cardholderName {
                userName = name
            }
            tableView.reloadData()
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
    }

}

