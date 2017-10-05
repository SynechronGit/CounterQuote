//
//  BaseViewController.swift
//  SyneScanner
//
//  Created by Kartik on 05/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet var bottomBtnConstraint: NSLayoutConstraint!
    @IBOutlet var goBackBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let constraint = bottomBtnConstraint {
            constraint.constant = constraint.constant + 20
                if (goBackBtn != nil) {
                    goBackBtn.layoutIfNeeded()
                }
            }        
        }

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
