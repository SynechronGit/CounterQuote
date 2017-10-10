//
//  RootViewController.swift
//  SyneScanner
//
//  Created by Markel on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {

    @IBOutlet weak var btnScanDocument: UIButton!
    @IBOutlet weak var topConstraintLblHeader: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintScanDocBtn: NSLayoutConstraint!

    @IBOutlet weak var lblWelcomeNote: UILabel!
    @IBOutlet weak var imgViewphonLogo: UIImageView!

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnScanDocument.setBorderToButton()
        bottomConstraintScanDocBtn.constant = -57
        topConstraintLblHeader.constant = -50
        lblWelcomeNote.alpha = 0
        imgViewphonLogo.alpha = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
   
   func startAnimation()
    {
        leftCurveLeading.constant = -10
        rightaCureveTrailing.constant = -16
        self.topConstraintLblHeader.constant = 30
        self.bottomConstraintScanDocBtn.constant = 20

        UIView.animate(withDuration: 1.0, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
        }, completion: { finish in
          
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.lblWelcomeNote.alpha = 1.0
                self.imgViewphonLogo.alpha = 1.0

            }, completion: nil)
            })
    }
     // MARK: - Button actions
    @IBAction func startScanning() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController")
        //let navigationController = UINavigationController(rootViewController: viewController!)
        self.navigationController?.pushViewController(viewController!, animated: true)
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
