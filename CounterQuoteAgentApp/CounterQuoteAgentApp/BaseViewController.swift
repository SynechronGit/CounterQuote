//
//  BaseViewController.swift
//  SyneScanner
//
//  Created by Kartik on 05/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

/**
 * BaseViewController with common initialization code
 */
class BaseViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet var bottomBtnConstraint: NSLayoutConstraint!
    @IBOutlet var leftCurveLeading: NSLayoutConstraint!
    @IBOutlet var rightaCureveTrailing: NSLayoutConstraint!
    @IBOutlet var goBackBtn: UIButton!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // For iPad code to move the buttons aligned to the bottom of the screen to move up by a constant value
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let constraint = bottomBtnConstraint {
            constraint.constant = constraint.constant + 20
                if (goBackBtn != nil) {
                    goBackBtn.layoutIfNeeded()
                }
            }        
        }
        hideLeftnRightCureve()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Animation methods
    // Method to hide left and right curves for animation purposes
    func hideLeftnRightCureve() {
        if leftCurveLeading != nil && rightaCureveTrailing != nil
        {
            leftCurveLeading.constant = -71
            rightaCureveTrailing.constant = -77
        }
    }
    
    // Animation start for left and right curves in each screen
    func startCurveAnimation() {
        leftCurveLeading.constant = 0
        rightaCureveTrailing.constant = 0
        
        UIView.animate(withDuration: 1.5, delay: 0.5,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)

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


// MARK: - Extension - Popup Alert
extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
