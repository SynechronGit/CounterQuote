//
//  AddCardViewController.swift
//  SyneScanner
//
//  Created by Kartik on 26/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

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
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var makePaymentButton: UIButton!
    @IBOutlet weak var emailIdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Create back button of type custom
        self.defaultValues()
        
        makePaymentButton.layer.borderWidth = 1
        makePaymentButton.layer.cornerRadius = 22
        makePaymentButton.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        
        let myBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        myBackButton.setBackgroundImage(UIImage(named: "BackArrow"), for: .normal)
        myBackButton.addTarget(self, action: #selector(AddCardViewController.popToRoot), for: .touchUpInside)
        myBackButton.sizeThatFits(CGSize(width: 22, height: 22))
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        self.makePaymentButton.isEnabled = true
        self.commonSetup()
        self.title  = "Payment Method"
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func popToRoot()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func defaultValues() {
        emailIdField.text = "igor.save68@gmail.com"
        emailIdField.keyboardType = .emailAddress
        month = "09"
        year = "17"
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
        else if(!isValidEmail(testStr: emailIdField.text!)) {
            let message = "Invalid Email Address!"
            self.showAlert(message: message)
        } else {
            let paymentReceiptVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentReceiptViewController") as! PaymentReceiptViewController
            for item in 0...1 {
                paymentReceiptVC.cardDetailsArray.append(cardDetailsArray[item])
            }
            paymentReceiptVC.cardDetailsArray.append(emailIdField.text!)
            self.navigationController?.pushViewController(paymentReceiptVC, animated: true)
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
extension AddCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardHeaderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! AddCardTableViewCell
        cell.descriptionField.placeholder = cardHeaderArray[indexPath.row]
        cell.descriptionField.tag = indexPath.row
        cell.actionDelegate = self
        switch indexPath.row {
        case 0:
            cell.descriptionField.rightViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            let image = UIImage(named: pickerArray.first!)
            imageView.image = image
            cell.descriptionField.rightView = imageView
            cell.descriptionField.text = "4111111111111111"
        case 1:
            cell.descriptionField.keyboardType = .alphabet
        case 2:
            cell.descriptionField.text = month?.appendingFormat("/%@", year!)
        case 3:
            cell.descriptionField.text = "119 Shaftesbury Avenue, Charing Cross NJ, 08817"
            cell.descriptionField.keyboardType = .default
        default:
            cell.descriptionField.keyboardType = .phonePad
            break
        }
        return cell
    }
    
}

//MARK: RightArrow action delegate methods
extension AddCardViewController: TextFieldActionDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func textFieldTappedAt(cell: AddCardTableViewCell) {
        indexPath = self.tableView.indexPath(for: cell)
        if indexPath?.row == 2 {
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
}

