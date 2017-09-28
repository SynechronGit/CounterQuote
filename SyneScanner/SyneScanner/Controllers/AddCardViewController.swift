//
//  AddCardViewController.swift
//  SyneScanner
//
//  Created by Kartik on 26/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController {
    let pickerArray = ["Mastercard", "Visa", "Discover", "American Express"]
    var pickerYearArray = [Int]()
    var pickerMonthArray = [String]()
    var isDatePicker = false
    var indexPath: IndexPath?
    var cardTypeText: String?
    var cardTypeName: CardTypeName = CardTypeName.cardType
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    var month: String?
    var year: String?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var makePaymentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Create back button of type custom
        let myBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        myBackButton.setBackgroundImage(UIImage(named: "BackArrow"), for: .normal)
        myBackButton.addTarget(self, action: #selector(ImagePreviewController.popToRoot), for: .touchUpInside)
        myBackButton.sizeThatFits(CGSize(width: 22, height: 22))
        self.makePaymentButton.isEnabled = true
        self.commonSetup()
        self.title  = "Add Card Details"
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyTapped(_ sender: Any) {
        var cardDetailsArray : [String] = [String]()
        for item in 0...CardTypeName.allValues.count {
            let indexPath = IndexPath(row: item, section: 0)
            let cell : AddCardTableViewCell? = self.tableView.cellForRow(at: indexPath) as! AddCardTableViewCell?
            if let details = cell?.headerField.text {
                cardDetailsArray.append(details)
            }
        }
        if cardDetailsArray.contains(where: { $0 == "" }) {
            let alert = UIAlertController(title: "Alert", message: "Please fill all card details!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            SharedData.sharedInstance.arrImage.removeAll()
            self.dismiss(animated: true, completion: nil)
        }
    }

    func commonSetup() {
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

}

//MARK: UITableViewDataSource delegate methods
extension AddCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CardTypeName.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! AddCardTableViewCell
        cell.actionDelegate = self
        cell.headerField.placeholder = CardTypeName.allValues[indexPath.row].rawValue
        switch indexPath.row {
        case 0:
            if let cardType = cardTypeText {
               let row = pickerArray.index(of: cardType)
                cell.cardImageView.image = UIImage(named: pickerArray[row!])
                cell.headerField.text = cardTypeText
            }
        case 1:
            cell.headerField.keyboardType = .alphabet
        case 3:
            cell.headerField.text = month?.appendingFormat(" %@", year!)
        case 5:
            cell.headerField.keyboardType = .emailAddress
        default:
            cell.headerField.keyboardType = .phonePad
            break
        }
        
        return cell
    }
}

//MARK: RightArrow action delegate methods
extension AddCardViewController: TextFieldActionDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func textFieldTappedAt(cell: AddCardTableViewCell) {
        indexPath = self.tableView.indexPath(for: cell)
        if indexPath?.row == 0 {
            let picker = UIPickerView()
            isDatePicker = false
            picker.showsSelectionIndicator = true
            picker.delegate = self
            picker.dataSource = self
            cell.headerField.addDoneOnKeyboardWithTarget(self, action: #selector(doneAction))
            cell.headerField.inputView = picker
        }
        
        if indexPath?.row == 3 {
            let picker = UIPickerView()
            isDatePicker = true
            picker.showsSelectionIndicator = true
            picker.delegate = self
            picker.dataSource = self
            cell.headerField.addDoneOnKeyboardWithTarget(self, action: #selector(doneAction))
            cell.headerField.inputView = picker
        }
    }
    
    func doneAction(button: UIBarButtonItem) {
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath!)
        self.tableView.reloadRows(at: indexPaths, with: .top)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if isDatePicker {
            return 2
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: 44))
        if !isDatePicker {
            let myImageView = UIImageView(frame: CGRect(x: myView.frame.size.width/4, y: ((myView.frame.size.height/2) - myView.frame.size.height/4), width: 22, height: 22))
            var rowString = String()
            cardTypeText = pickerArray.first
            
            rowString = pickerArray[row]
            myImageView.image = UIImage(named: pickerArray[row])
            
            let myLabel = UILabel(frame: CGRect(x: myImageView.frame.origin.x + myImageView.frame.size.width + 10, y: myImageView.frame.origin.y, width: pickerView.bounds.width - 100, height: myImageView.bounds.height))
            myLabel.text = rowString
            myView.addSubview(myLabel)
            myView.addSubview(myImageView)
            return myView
        } else {
            let myLabel = UILabel(frame: CGRect(x: myView.frame.size.width/4 + 10, y: 0, width: pickerView.bounds.width - 100, height: myView.bounds.height))
            switch component {
            case 0:
                month = pickerMonthArray.first
                myLabel.text = pickerMonthArray[row]
            case 1:
                year = String(pickerYearArray.first!)
                myLabel.text = "\(pickerYearArray[row])"
            default:
                myLabel.text = ""
                break
            }
            myView.addSubview(myLabel)
            return myView
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isDatePicker {
            switch component {
            case 0:
                return pickerMonthArray.count
            case 1:
                return pickerYearArray.count
            default:
                return 0
            }
        } else {
            return pickerArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isDatePicker {
            switch component {
            case 0:
                month = pickerMonthArray[row]
            case 1:
                year = "\(pickerYearArray[row])"
            default:
                break
            }
        } else {
            cardTypeText = pickerArray[row]
        }
    }
    
}

public enum CardTypeName: String {
    case cardType = "Card Type"
    case cardName = "Card Holder Name"
    case cardNumber = "Card Number"
    case expiryDate = "Expiry Date"
    case cvvCode = "CVV"
    case emailId = "Email ID"
    
    static let allValues = [cardType, cardName, cardNumber, expiryDate, cvvCode, emailId]
    
    
    public init(rawValue pRawValue :String) {
        var aValue :CardTypeName = CardTypeName.cardType
        for aCase in CardTypeName.allValues {
            if aCase.rawValue == pRawValue {
                aValue = aCase
                break
            }
        }
        self = aValue
    }
}
