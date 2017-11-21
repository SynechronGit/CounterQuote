//
//  LiveQouteFormViewController.swift
//  SyneScanner
//
//  Created by Kartik on 20/11/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD

class LiveQouteFormViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet weak var tableForm: UITableView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var lblActilaPrice: UILabel!
    @IBOutlet weak var lblSavedaAmount: UILabel!
    @IBOutlet weak var imgCompanyLogo: UIImageView!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var bottomConstraintBackBtn: NSLayoutConstraint!

    var isAnimationShow = false
    var agentCallVc:AgentCallViewController?
    var termsnQVc:TermsnConditionViewController?
    var dataArr:NSArray?
    var companyDetails:[String:String]?
    
    var quoteType: String?
    var indexPath: IndexPath?
    var dateString: String?
    
    var quoteData: [String:AnyObject]?
    
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        companyDetails = ["companyName": "Company 1", "price": "3500","imgName": "comp1"]
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(LiveQouteFormViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
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
        imgCompanyLogo.image = UIImage(named: (companyDetails?["imgName"])!)
        
        self.bottomConstraintBackBtn.constant = -80
        self.tableForm.alpha = 0
        self.tableForm.layer.masksToBounds = true
        
        lblCompanyName.text =  companyDetails?["companyName"]
        
        proceedBtn.setBorderToButton()
        
        let actualPriceStr:String = (companyDetails?["price"])!
        lblActilaPrice.text = "$" + " " + actualPriceStr + "/y"
        let actualPrice:Int = Int(actualPriceStr)!
        let savedPrice = 4000 - actualPrice
        lblSavedaAmount.text = String(format:"You Saved $ %d",savedPrice)
        viewAmount.layer.cornerRadius = 8
    }
    
    func defaultsChanged() {
        //        if UserDefaults.standard.bool(forKey: "demo_preference") {
        loadDataFromPlist()
        //        } else {
        //            loadDataFromModel()
        //        }
    }
    
    /**
     * Method that will load the plist containing the quote properties
     */
    func loadDataFromPlist() {
        var path: String
        
//        switch UserDefaults.standard.value(forKey: "business_preference") as? String {
//        case "1"?:
//            path = Bundle.main.path(forResource: "QuoteFormData", ofType: "plist")!
//        case "2"?:
//            path = Bundle.main.path(forResource: "QuoteFormData-HomeRenter", ofType: "plist")!
//        case "3"?:
//            path = Bundle.main.path(forResource: "QuoteFormData-HomeOwner", ofType: "plist")!
//        default:
//            path = Bundle.main.path(forResource: "QuoteFormData", ofType: "plist")!
//            break
//        }
        
        path = Bundle.main.path(forResource: "OCRMapper", ofType: "plist")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
        dataArr = plist as? NSArray
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
    
    
    //MARK: UIButton action methods
    @IBAction func proceedBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "LiveNavToCallVc", sender: nil)
        }
    }
    
    
    @IBAction   func backBtnClicked() {
        let vc = self.navigationController?.viewControllers[3]
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    
    
    @IBAction   func callBtnClicked() {
        // Create the AlertController and add its action like button in Actionsheet
        // Added 2 buttons for call and 1 cancel button
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let saveActionButton = UIAlertAction(title: "Agent Call Me", style: .default)
        { _ in
            self.showCallUsView()
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Call Agent Now", style: .default)
        { _ in
            self.callOnNumber()
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .destructive) { _ in
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
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
    
    // Show terms and conditions on a custom alert screen
    @IBAction func termsNConditionBtnTapped() {
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
    
    //MARK: - Agent call methods
    //Call on an agent number
    func callOnNumber() {
        
        self.performSegue(withIdentifier: "presentVideoCallVc", sender: nil)
        //        if let url = URL(string: "tel://\("+91999999999")"), UIApplication.shared.canOpenURL(url) {
        //            if #available(iOS 10, *) {
        //                UIApplication.shared.open(url)
        //            } else {
        //                UIApplication.shared.openURL(url)
        //            }
        //        }
    }
    
    //Call us view with fileds name and phone to be added
    func showCallUsView() {
        let dict:NSDictionary = dataArr?.object(at: 0) as! NSDictionary
        let arr:NSArray = dict.value(forKey: "data") as! NSArray
        let data:NSDictionary = arr.object(at: 1) as! NSDictionary
        
        agentCallVc = self.storyboard?.instantiateViewController(withIdentifier: "agentCallVc") as? AgentCallViewController
        agentCallVc?.delegate = self
        agentCallVc?.nameText = (data.value(forKey: "value") as? String)!
        agentCallVc?.phoneText = "+91999999999"
        self.view.addSubview((agentCallVc?.view)!)
        
        UIView.animate(withDuration: 0.8, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.agentCallVc?.view.frame = self.view.frame
        }, completion: { finish in
            
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
extension LiveQouteFormViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArr?.count)!
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell:QuoteFromSectionHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell")! as! QuoteFromSectionHeaderTableViewCell
//        let dict:NSDictionary = dataArr?.object(at: section ) as! NSDictionary
//        cell.headerLabel.text = dict.value(forKey: "title") as? String
//        return cell
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 48
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.indexPath = indexPath
        
        let cell:QuoteFormTableViewCell = tableView.dequeueReusableCell(withIdentifier: "formCell", for: indexPath ) as! QuoteFormTableViewCell
        cell.quoteDelegate = self
        
        let dict: NSDictionary = dataArr?.object(at: indexPath.row) as! NSDictionary
//        let arr: NSArray = dict.value(forKey: "data") as! NSArray
//        let data: NSDictionary = arr.object(at: indexPath.row) as! NSDictionary
        
        var headerText = dict.value(forKey: "Title") as? String
        headerText!.append("*")
        let font:UIFont? = cell.headerLabel.font
        let fontSuper:UIFont? = UIFont(name: (font?.fontName)!, size:10)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: headerText!, attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:attString.length - 1,length:1))
        cell.headerLabel.attributedText = attString
        
        
        cell.descriptionField.placeholder =  dict.value(forKey: "Title") as? String
        cell.descriptionField.text = quoteData?[dict.value(forKey: "Key") as! String] as? String
        
        
//        quoteType = data.value(forKey: "type") as? String
//        if quoteType == QuoteFormFieldType.TYPE_CURRENCY.rawValue {
//            cell.descriptionField.keyboardType = .numbersAndPunctuation
//        } else if quoteType == QuoteFormFieldType.TYPE_NUMBER.rawValue {
//            cell.descriptionField.keyboardType = .numberPad
//        } else if quoteType == QuoteFormFieldType.TYPE_DATE.rawValue {
//            cell.descriptionField.keyboardType = .numbersAndPunctuation
//        } else {
            cell.descriptionField.keyboardType = .asciiCapable
//        }
        
        if indexPath.row == (dataArr?.count)! - 1
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

//MARK: - AgentCallViewControllerDelegate delegate methods
extension LiveQouteFormViewController: AgentCallViewControllerDelegate {
    func dismissCallUsView() {
        agentCallVc?.view.removeFromSuperview()
        agentCallVc = nil
    }
}

//MARK: - TermsnConditionViewControllerDelegate delegate methods
extension LiveQouteFormViewController: TermsnConditionViewControllerDelegate {
    func dismissTnQView() {
        termsnQVc?.view.removeFromSuperview()
        termsnQVc = nil
    }
}


//MARK: TableViewCell textfield delegate methods
extension LiveQouteFormViewController: QuoteTextFieldDelegate {
    // Textfield tap to show picker view for year and month of card expiry date
    func textFieldTappedAt(cell: QuoteFormTableViewCell) {
//        indexPath = self.tableForm.indexPath(for: cell)
//        let data:NSDictionary = dataArr?.object(at: indexPath!.row) as! NSDictionary
//        quoteType = data.value(forKey: "type") as? String
//        if quoteType == QuoteFormFieldType.TYPE_DATE.rawValue {
//            let picker = UIDatePicker()
//            picker.datePickerMode = .date
//            cell.descriptionField.inputView = picker
//            picker.addTarget(self, action: #selector(LiveQouteFormViewController.dateChanged), for: .valueChanged)
//        }
//        if quoteType == QuoteFormFieldType.TYPE_CURRENCY.rawValue {
//            cell.descriptionField.addTarget(self, action: #selector(LiveQouteFormViewController.myTextFieldDidChange), for: .editingChanged)
//        }
    }
    
    func textFieldReturnedFor(cell: QuoteFormTableViewCell) {
        indexPath = self.tableForm.indexPath(for: cell)
        let dict: NSDictionary = dataArr?[(indexPath?.row)!] as! NSDictionary
//        quoteData = dataArr?.object(at: (indexPath?.row)!)
//        quoteType = quoteData?.value(forKey: "type") as? String
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath!)
        
//        if quoteType == QuoteFormFieldType.TYPE_CURRENCY.rawValue {
//            if let amountString = cell.descriptionField.text?.currencyInputFormatting() {
//                cell.descriptionField.text = amountString
//            }
//        }
//        if quoteType == QuoteFormFieldType.TYPE_DATE.rawValue {
//            if dateString == nil {
//                let date = Date()
//                let formatter = DateFormatter()
//                formatter.dateFormat = "dd/MM/yyyy"
//                dateString = formatter.string(from: date)
//            }
//            cell.descriptionField.text = dateString
//            dateString = nil
//        }

        
        quoteData?[dict.value(forKey: "Key") as! String] = cell.descriptionField.text as AnyObject
        self.tableForm.reloadRows(at: indexPaths, with: .top)
    }
}

