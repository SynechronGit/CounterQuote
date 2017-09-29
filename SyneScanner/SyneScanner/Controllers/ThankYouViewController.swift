//
//  ThankYouViewController.swift
//  SyneScanner
//
//  Created by Markel on 29/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {
    @IBOutlet weak var btnFeedback: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnFeedback.layer.borderWidth = 1
        btnFeedback.layer.cornerRadius = 22
        btnFeedback.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func feedBackBtnClicked() {
        SharedData.sharedInstance.arrImage.removeAll()
        
        let vc = self.navigationController?.viewControllers[1]
        self.navigationController?.popToViewController(vc!, animated: true)

            
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
