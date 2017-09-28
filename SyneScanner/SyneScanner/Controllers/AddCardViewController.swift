//
//  AddCardViewController.swift
//  SyneScanner
//
//  Created by Kartik on 26/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController {
    var cardDetailsArray = [String]()
    let cardSecurityArray = ["Valid Thru", "CVV"]
    let pickerArray = ["Mastercard", "Visa", "Discover", "American Express"]
    var pickerYearArray = [Int]()
    var pickerMonthArray = [String]()
    var indexPath: IndexPath?
    var cardTypeText: String?
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    var month: String?
    var year: String?
    
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var cardVerifiedImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var validThruLabel: UILabel!
    @IBOutlet weak var cardHolderLabel: UILabel!
    
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
        for item in 0...cardDetailsArray.count {
            let indexPath = IndexPath(row: item, section: 0)
            let cell : AddCardTableViewCell? = self.tableView.cellForRow(at: indexPath) as! AddCardTableViewCell?
            if let details = cell?.descriptionField.text {
                cardDetailsArray.append(details)
            }
        }
        if cardDetailsArray.contains(where: { $0 == "" }) {
            let alert = UIAlertController(title: "Alert", message: "Please fill all card details!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let paymentReceiptVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentReceiptViewController")
            self.navigationController?.pushViewController(paymentReceiptVC!, animated: true)
        }
    }

    func commonSetup() {
        cardDetailsArray = ["Card number", "Cardholder name", "Email Address (receipt will be sent on this ID)", "Mailing Address"]
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
        return cardDetailsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "secureCell") as! AddCardSecureTableViewCell
            cell.validField.text = month?.appendingFormat(" %@", year!)
            cell.actionDelegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! AddCardTableViewCell
            cell.actionDelegate = self
            if indexPath.row < 2 {
                cell.headerLabel.text = cardDetailsArray[indexPath.row]
            } else if indexPath.row > 2 {
                cell.headerLabel.text = cardDetailsArray[indexPath.row - 1]
            }
            
            switch indexPath.row {
            case 1:
                cell.descriptionField.keyboardType = .alphabet
            case 3:
                cell.descriptionField.keyboardType = .emailAddress
            case 4:
                cell.descriptionField.keyboardType = .default
            default:
                cell.descriptionField.keyboardType = .phonePad
                break
            }
            return cell
        }
    }
}

//MARK: RightArrow action delegate methods
extension AddCardViewController: SecureTextFieldActionDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func secureTextFieldTappedAt(cell: AddCardSecureTableViewCell) {
        indexPath = self.tableView.indexPath(for: cell)
        if indexPath?.row == 2 {
            validThruLabel.text = cell.validField.text
            let picker = UIPickerView()
            picker.showsSelectionIndicator = true
            picker.delegate = self
            picker.dataSource = self
            cell.validField.addDoneOnKeyboardWithTarget(self, action: #selector(doneSecureAction))
            cell.validField.inputView = picker
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
            month = pickerMonthArray[row]
        case 1:
            year = "\(pickerYearArray[row])"
        default:
            break
        }
    }
}

extension AddCardViewController: TextFieldActionDelegate {
    func textFieldTappedAt(cell: AddCardTableViewCell) {
        indexPath = self.tableView.indexPath(for: cell)
        switch indexPath?.row {
        case 0?:
            cardNumberLabel.text = cell.descriptionField.text
            cardTypeImageView.image = UIImage(named: pickerArray.first!)
        case 1?:
            cardHolderLabel.text = cell.descriptionField.text
        default:
            break
        }
    }
}


