//
//  ThankYouViewController.swift
//  SyneScanner
//
//  Created by Markel on 29/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class ThankYouViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet weak var btnFeedback: UIButton!
    @IBOutlet weak var lblheader: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var imgViewRightMark: UIImageView!
    @IBOutlet weak var bottomConstraintcompleteBtn: NSLayoutConstraint!
    @IBOutlet weak var topConstraintLblHeader: NSLayoutConstraint!

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
    
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }
    
    /**
     * Method that will configure UI initializations
     */
    // MARK: - Configure UI
    func configureUI() {
        self.bottomConstraintcompleteBtn.constant = -47
        self.lblNote.alpha = 0
        self.imgViewRightMark.alpha = 0
        topConstraintLblHeader.constant = -50
        btnFeedback.setBorderToButton()
    }
    
    /**
     * Method that will start view animations
     */
    // MARK: - Start animation
    func startAnimation() {
        leftCurveLeading.constant = -10
        rightaCureveTrailing.constant = -16

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

    //MARK: UIButton action methods
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
