//
//  ThankYouViewController.swift
//  SyneScanner
//
//  Created by Markel on 29/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class ThankYouViewController: BaseViewController {
    @IBOutlet weak var btnFeedback: UIButton!
    @IBOutlet weak var lblheader: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var imgViewRightMark: UIImageView!
    @IBOutlet weak var bottomConstraintcompleteBtn: NSLayoutConstraint!
    @IBOutlet weak var topConstraintLblHeader: NSLayoutConstraint!


    override func viewDidLoad() {
        self.bottomConstraintcompleteBtn.constant = -47
        self.lblNote.alpha = 0
        self.imgViewRightMark.alpha = 0
        topConstraintLblHeader.constant = -50

        super.viewDidLoad()
      
        btnFeedback.setBorderToButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }
    
    func startAnimation()
    {
        leftCurveLeading.constant = 0
        rightaCureveTrailing.constant = 0
        self.bottomConstraintcompleteBtn.constant = 20
        self.topConstraintLblHeader.constant = 30

        UIView.animate(withDuration: 1.2, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
        }, completion: { finish in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
                self.lblNote.alpha = 1
                self.imgViewRightMark.alpha = 1

            }, completion:  { finish in
            })
        })
        
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
