//
//  SplashScreenViewController.swift
//  SyneScanner
//
//  Created by Markel on 22/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

public typealias SplashAnimatableCompletion = () -> Void
public typealias SplashAnimatableExecution = () -> Void

class SplashScreenViewController: BaseViewController {

    // MARK: - Properties
    @IBOutlet var imgLogo: UIImageView!
    var timer:Timer?
    var duration: Double = 2.0
    open var delay: Double = 0.5
    @IBOutlet weak var topConstraintLblHeader: NSLayoutConstraint!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topConstraintLblHeader.constant = -50

        self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.endSplashScreenView), userInfo: nil, repeats: false)
        //self.startTokenApi()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addLabelAnimation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Method that will label animations
     */
    // MARK: - Label Animation
    func addLabelAnimation() {
        self.topConstraintLblHeader.constant = 60

        UIView.animate(withDuration: 1.5, delay: 0.5,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.8,
                                   options: .curveEaseInOut, animations: {
                                    self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    // MARK: - Perform Segue
    func endSplashScreenView() {
        self.performSegue(withIdentifier: "pushToRootVc", sender: nil)
        self.timer?.invalidate()
        self.timer = nil
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


////MARK: StartAuthorizationToken methods
//extension SplashScreenViewController: OCRTokenDelegate {
//    
//    //Start Token service method 
//    func startTokenApi() {
//        let startTokenProxy =  OCRTokenProxy()
//        startTokenProxy.delegate = self
//        startTokenProxy.startOCRTokenApi(userName: SharedData.sharedInstance.userName, password: SharedData.sharedInstance.password, grantType: SharedData.sharedInstance.grantType)
//    }
//    
//    
//    func getTokenSuccess(responseData: [String : AnyObject]) {
//        SharedData.sharedInstance.authToken = (responseData["token_type"] as! String) + " " + (responseData["access_token"] as! String)
//    }
//    
//    
//    func getTokenFailed(errorMessage: String) {
//        SharedData.sharedInstance.authToken = "bearer "
//    }
//}
//
