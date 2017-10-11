//
//  AgentCallViewController.swift
//  SyneScanner
//
//  Created by Kartik on 06/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

//MARK: - AgentCallViewControllerDelegate protocol
protocol AgentCallViewControllerDelegate {
    /**
     * Method that will dismiss the Call us alert view
     */
    func dismissCallUsView()
}


class AgentCallViewController: UIViewController {
    // MARK: - Properties
    var nameText: String = ""
    var phoneText: String = ""
    var delegate:AgentCallViewControllerDelegate?

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet var callUsBtn: UIButton!
    @IBOutlet var centerView: UIView!
    @IBOutlet weak var phoneField: UITextField!
    
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Method that will configure UI with initializations
     */
    // MARK: - Configure UI
    func configureUI() {
        centerView.layer.cornerRadius = 10
        centerView.layer.masksToBounds = true
        callUsBtn.setBorderToButton()
        
        nameField.text = nameText
        phoneField.text = phoneText
    }
    
    //MARK: UIButton action methods
    @IBAction func callUsBtnClicked(_ sender: Any) {
        delegate?.dismissCallUsView()
    }
    
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        delegate?.dismissCallUsView()
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

//MARK: UITextField delegate methods
extension AgentCallViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



