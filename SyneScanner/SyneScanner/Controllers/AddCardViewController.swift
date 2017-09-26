//
//  AddCardViewController.swift
//  SyneScanner
//
//  Created by Kartik on 26/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController {
    let pickerArray = ["MasterCard", "VISA"]
    var pickerYearArray = [Int]()
    var pickerMonthArray = [String]()
    var isDatePicker = false
    var indexPath: IndexPath?
    var cardTypeText: String?
    var cardTypeName: CardTypeName = CardTypeName.cardType
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    var month: String? = "1"
    var year: String? = "2017"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        SharedData.sharedInstance.arrImage.removeAll()
        self.dismiss(animated: true, completion: nil)
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
            cell.headerField.text = cardTypeText
            break
        case 1:
            cell.headerField.keyboardType = .alphabet
            break
        case 3:
            cell.headerField.text = month?.appendingFormat(" %@", year!)
            break
        case 5:
            cell.headerField.keyboardType = .emailAddress
            break
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isDatePicker {
            switch component {
            case 0:
                return pickerMonthArray[row]
            case 1:
                return "\(pickerYearArray[row])"
            default:
                return nil
            }
        } else {
            return pickerArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isDatePicker {
            switch component {
            case 0:
                month = String(row + 1)
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
