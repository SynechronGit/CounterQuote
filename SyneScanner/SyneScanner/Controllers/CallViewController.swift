//
//  CallViewController.swift
//  SyneScanner
//
//  Created by Markel on 16/11/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SVProgressHUD

class CallViewController: BaseViewController {

    var isAnimationShow = false
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var callNowBtn: UIButton!
    @IBOutlet weak var callLaterBtn: UIButton!

    @IBOutlet weak var bottomConstraintBackBtn: NSLayoutConstraint!

    var agentCallVc:AgentCallViewController?
    var dataArr:NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        self.bottomConstraintBackBtn.constant = -80
        proceedBtn.setBorderToButton()
        callNowBtn.setBorderToButton()
        callLaterBtn.setBorderToButton()
        loadDataFromPlist()
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
           
        })
        
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
        
       
    }

    //MARK: UIButton action methods
    @IBAction func proceedBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 1) {
            self.performSegue(withIdentifier: "NavToCompanyOptionVc", sender: nil)
        }
    }
    
    
    @IBAction   func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction   func callNowBtnTapped() {
        self.performSegue(withIdentifier: "NavToVideoVc", sender: nil)

    }
    @IBAction   func callLaterBtnTapped() {
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

}
//MARK: - AgentCallViewControllerDelegate delegate methods
extension CallViewController: AgentCallViewControllerDelegate {
    func dismissCallUsView() {
        agentCallVc?.view.removeFromSuperview()
        agentCallVc = nil
    }
}
