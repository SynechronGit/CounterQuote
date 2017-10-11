//
//  TermsnConditionViewController.swift
//  SyneScanner
//
//  Created by Markel on 10/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
protocol TermsnConditionViewControllerDelegate {
    func dismissTnQView()
}
class TermsnConditionViewController: UIViewController {
    // MARK: - Properties
    var delegate:TermsnConditionViewControllerDelegate?
    
    @IBOutlet var acceptBtn: UIButton!
    @IBOutlet var centerView: UIView!
    
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
    
    func configureUI() {
        centerView.layer.cornerRadius = 10
        centerView.layer.masksToBounds = true
        acceptBtn.setBorderToButton()
    }
    
    //MARK: UIButton action methods
    @IBAction func acceptBtnClicked(_ sender: Any) {
        delegate?.dismissTnQView()
    }
    @IBAction func closeBtnClicked(_ sender: Any) {
        delegate?.dismissTnQView()
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
