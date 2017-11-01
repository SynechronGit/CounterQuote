//
//  QuoteFormViewController.swift
//  SyneScanner
//
//  Created by Markel on 06/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class QuoteFormViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet weak var tableForm: UITableView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblActilaPrice: UILabel!
    @IBOutlet weak var lblSavedaAmount: UILabel!
    @IBOutlet weak var imgCompanyLogo: UIImageView!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDiscard: UIButton!

    var isAnimationShow = false
    var isEditMode = false

    var dataArr:NSArray?
//    var companyDetails:[String:String]?
    
    var quoteType: String?
    var indexPath: IndexPath?
    var dateString: String?
    
    var listDict: NSDictionary?
    var dictArray: NSArray?
    var quoteData: NSDictionary?

    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(QuoteFormViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        defaultsChanged()
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
        btnEdit.setBorderToButton()
        btnDiscard.setBorderToButton()

        imgCompanyLogo.image = UIImage(named: "comp1")

        self.tableForm.alpha = 0
        self.tableForm.layer.masksToBounds = true

        lblCompanyName.text =  "Company 1"
        

        let actualPriceStr:String = "2000"
        lblActilaPrice.text = "$" + " " + actualPriceStr + "/y"
        let actualPrice:Int = Int(actualPriceStr)!
        let savedPrice = 4000 - actualPrice
        lblSavedaAmount.text = String(format:"You Saved $ %d",savedPrice)
        viewAmount.layer.cornerRadius = 8
    }
    
    func defaultsChanged() {
        loadDataFromPlist()
    }
    
    /**
     * Method that will load the plist containing the quote properties
     */
    func loadDataFromPlist() {
        var path: String
        
        switch UserDefaults.standard.value(forKey: "business_preference") as? String {
        case "1"?:
            path = Bundle.main.path(forResource: "QuoteFormData", ofType: "plist")!
        case "2"?:
            path = Bundle.main.path(forResource: "QuoteFormData-HomeRenter", ofType: "plist")!
        case "3"?:
            path = Bundle.main.path(forResource: "QuoteFormData-HomeOwner", ofType: "plist")!
        default:
            path = Bundle.main.path(forResource: "QuoteFormData", ofType: "plist")!
            break
        }
        
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
        dataArr = plist as? NSArray
        
//        if !UserDefaults.standard.bool(forKey: "demo_preference")
//        {
//            var pDict = NSDictionary()
//            var pArr = NSArray()
//            
//            for i in 0..<(dataArr?.count)! {
//                pDict = dataArr?.object(at: i) as! NSDictionary
//                pArr = pDict.value(forKey: "data") as! NSArray
//                pArr.setValue("", forKey: "value")
//            }
//            
//            if listDict == nil {
//                listDict = pDict
//            }
//            if dictArray == nil {
//                dictArray = pArr
//            }
//        }
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
    
    @IBAction   func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction   func btnEditClicked() {
        if isEditMode
        {
            isEditMode = false
            btnDiscard.isEnabled = false
            btnEdit.setTitle("EDIT", for: .normal)

        }
        else
        {
            isEditMode = true
            btnDiscard.isEnabled = true
            btnEdit.setTitle("SAVE", for: .normal)

        }
        tableForm.reloadData()
    }
    
    @IBAction   func btnDiscardClicked() {
        
        btnEditClicked()

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
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
    
    //MARK: - UIDatePicker delegate method
    func dateChanged(_ sender: UIDatePicker) {
        dateString = nil
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            var indexPaths = [IndexPath]()
            indexPaths.append(indexPath!)
            dateString = String(day) + "/" + String(month) + "/" + String(year)
        }
    }
    
    func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
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
        self.indexPath = indexPath
        
        let cell:QuoteFormTableViewCell = tableView.dequeueReusableCell(withIdentifier: "formCell", for: indexPath ) as! QuoteFormTableViewCell
        cell.quoteDelegate = self
        
        let dict: NSDictionary = dataArr?.object(at: indexPath.section) as! NSDictionary
        let arr: NSArray = dict.value(forKey: "data") as! NSArray
        let data: NSDictionary = arr.object(at: indexPath.row) as! NSDictionary
        
        var headerText = data.value(forKey: "heading") as? String
        headerText!.append("*")
        let font:UIFont? = cell.headerLabel.font
        let fontSuper:UIFont? = UIFont(name: (font?.fontName)!, size:10)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: headerText!, attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:attString.length - 1,length:1))
        cell.headerLabel.attributedText = attString
        
//        if UserDefaults.standard.bool(forKey: "demo_preference") {
//            cell.descriptionField.text =  data.value(forKey: "value") as? String
//        }
//        
//        else
//        {
//            cell.descriptionField.placeholder =  data.value(forKey: "heading") as? String
//            listDict = dataArr?.object(at: indexPath.section) as? NSDictionary
//            dictArray = listDict?.value(forKey: "data") as? NSArray
//            quoteData = dictArray?.object(at: indexPath.row) as? NSDictionary
//            cell.descriptionField.text = quoteData?.value(forKey: "value") as? String
//       }
//        
        
                    cell.descriptionField.text =  data.value(forKey: "value") as? String

        
        cell.descriptionField.isEnabled = isEditMode

        
        quoteType = data.value(forKey: "type") as? String
        if quoteType == QuoteFormFieldType.TYPE_CURRENCY.rawValue {
            cell.descriptionField.keyboardType = .numbersAndPunctuation
        } else if quoteType == QuoteFormFieldType.TYPE_NUMBER.rawValue {
            cell.descriptionField.keyboardType = .numberPad
        } else if quoteType == QuoteFormFieldType.TYPE_DATE.rawValue {
            cell.descriptionField.keyboardType = .numbersAndPunctuation            
        } else {
            cell.descriptionField.keyboardType = .asciiCapable
        }
        
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




//MARK: - QuoteFormFieldType enum
public enum QuoteFormFieldType : String {
    case TYPE_STRING = "String"
    case TYPE_NUMBER = "Number"
    case TYPE_DATE = "Date"
    case TYPE_CURRENCY = "Currency"
    
    static let allValues = [TYPE_STRING, TYPE_NUMBER, TYPE_DATE, TYPE_CURRENCY]
    
    
    public init(rawValue pRawValue :String) {
        var aValue :QuoteFormFieldType = QuoteFormFieldType.TYPE_STRING
        for aCase in QuoteFormFieldType.allValues {
            if aCase.rawValue == pRawValue {
                aValue = aCase
                break
            }
        }
        self = aValue
    }
}


//MARK: TableViewCell textfield delegate methods
extension QuoteFormViewController: QuoteTextFieldDelegate {
    // Textfield tap to show picker view for year and month of card expiry date
    func textFieldTappedAt(cell: QuoteFormTableViewCell) {
        indexPath = self.tableForm.indexPath(for: cell)
        let dict:NSDictionary = dataArr?.object(at: indexPath!.section) as! NSDictionary
        let arr:NSArray = dict.value(forKey: "data") as! NSArray
        let data:NSDictionary = arr.object(at: indexPath!.row) as! NSDictionary
        quoteType = data.value(forKey: "type") as? String
        if quoteType == QuoteFormFieldType.TYPE_DATE.rawValue {
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            cell.descriptionField.inputView = picker
            picker.addTarget(self, action: #selector(QuoteFormViewController.dateChanged), for: .valueChanged)
        }
        if quoteType == QuoteFormFieldType.TYPE_CURRENCY.rawValue {
            cell.descriptionField.addTarget(self, action: #selector(QuoteFormViewController.myTextFieldDidChange), for: .editingChanged)
        }
    }
    
    func textFieldReturnedFor(cell: QuoteFormTableViewCell) {
        indexPath = self.tableForm.indexPath(for: cell)
        listDict = dataArr?.object(at: (indexPath?.section)!) as? NSDictionary
        dictArray = listDict?.value(forKey: "data") as? NSArray
        quoteData = dictArray?.object(at: (indexPath?.row)!) as? NSDictionary
        quoteType = quoteData?.value(forKey: "type") as? String
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath!)
        
        if quoteType == QuoteFormFieldType.TYPE_CURRENCY.rawValue {
            if let amountString = cell.descriptionField.text?.currencyInputFormatting() {
                cell.descriptionField.text = amountString
            }
        }
        if quoteType == QuoteFormFieldType.TYPE_DATE.rawValue {
            if dateString == nil {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                dateString = formatter.string(from: date)
            }
            cell.descriptionField.text = dateString
            dateString = nil
        }
        quoteData?.setValue(cell.descriptionField.text, forKey: "value")
        self.tableForm.reloadRows(at: indexPaths, with: .top)
    }
}


extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}


extension UITableViewCell
{
    func setBorderTocell(indexPath:IndexPath,tableView:UITableView) {
        let cornerRadius: CGFloat = 12
        self.backgroundColor = .clear
        
        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = self.bounds.insetBy(dx: 20, dy: 0)
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
        
        let testView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = .clear
        self.backgroundView = testView
        
    }
    
    /**
     * Method that will add shadow effects to UITableView cells
     */
    func addShadowToCell() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.10
        self.layer.shadowRadius = 4
    }
}
