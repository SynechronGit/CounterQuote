//
//  AgentCallViewController.swift
//  SyneScanner
//
//  Created by Kartik on 06/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
protocol AgentCallViewControllerDelegate {
    func dismissCallUsView()
}
class AgentCallViewController: UIViewController {
    var delegate:AgentCallViewControllerDelegate?

    @IBOutlet var callUsBtn: UIButton!
    @IBOutlet var centerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        centerView.layer.cornerRadius = 10
        centerView.layer.masksToBounds = true

        callUsBtn.setBorderToButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

