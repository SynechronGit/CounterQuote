//
//  LoaderViewController.swift
//  SyneScanner
//
//  Created by Markel on 29/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class LoaderViewController: BaseViewController {

     // MARK: - Properties
    @IBOutlet var searchImageVIew: UIImageView!
    @IBOutlet var lblNote:UILabel!
    var ocrTimer:Timer?
    var ocrData:[String:AnyObject]?
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LoaderViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        defaultsChanged()
        configurUI()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
        if UserDefaults.standard.bool(forKey: "demo_preference") {
            //pushToQuoteVc()
        } else {
            self.startOCR()
        }
    }
    
    func defaultsChanged() {
        if UserDefaults.standard.bool(forKey: "carriers_preference") {
            lblNote.text = "We are collecting more than 287 offers for you. We are now making insurance companies fight for your business. We will present you their offers in a bit."
        } else {
            lblNote.text = "Working to get a more competetive quote for you."
        }
    }
    
    /**
     * Method that will configure UI intializations
     */
    // MARK: - Configure UI
    func configurUI() {
        lblNote.alpha = 0
        searchImageVIew.alpha = 0
    }
    
    /**
     * Method that will start view animations
     */
    func startAnimation() {
        leftCurveLeading.constant = -10
        rightaCureveTrailing.constant = -16
        
        UIView.animate(withDuration: 1.0, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
        }, completion: { finish in
            // Search animation start
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
                self.addSearchAnimation()
            }, completion: { finish in
                // Text View animation start
                UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseIn, animations: {
                    self.lblNote.alpha = 1
                    self.searchImageVIew.alpha = 1
                }, completion: { finish in
                    // Perform segue after interval

                    if UserDefaults.standard.bool(forKey: "demo_preference") {

                    Timer.scheduledTimer(timeInterval: 5,
                                         target: self,
                                         selector: #selector(self.pushToQuoteVc),
                                         userInfo: nil,
                                         repeats: false)
                    }
                    else{
                     self.ocrTimer =    Timer.scheduledTimer(timeInterval: 10,
                                             target: self,
                                             selector: #selector(self.startOCR),
                                             userInfo: nil,
                                             repeats: true)
                    }
                    
                    
                })
            })
        })
    }

    func addSearchAnimation() {
        searchImageVIew.loadGif(name: "Search_animation")
    }
    
    
    func pushToQuoteVc() {
        if UserDefaults.standard.bool(forKey: "demo_preference") {
            self.performSegue(withIdentifier: "NavToQuoteVc", sender: nil)
        } else {
            self.performSegue(withIdentifier: "NavToLiveQuoteVc", sender: nil)
        }
    }
    
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NavToLiveQuoteVc" {
            let liveQuoteVC : LiveQouteFormViewController = segue.destination as! LiveQouteFormViewController
            liveQuoteVC.quoteData = ocrData
        }
    }
 

}

//MARK: - GetOCRProxyDelgate methods
extension LoaderViewController:GetOCRProxyDelgate
{
    // Start OCR service
    func startOCR() {
        let getOCRproxy =  GetOCRProxy()
        getOCRproxy.delegate = self
        getOCRproxy.callGetOCRApi()
    }
    
    func getOCRSuccess(responseData:[String:AnyObject]) {
        print(responseData)
        let data = responseData["Result"]
        if data is NSNull
        {
            return
        }
            ocrData = responseData["Result"] as? [String : AnyObject]
            ocrTimer?.invalidate()
            ocrTimer = nil
            self.performSegue(withIdentifier: "NavToLiveQuoteVc", sender: nil)
    }
    
    func getOCRFailed(errorMessage:String) {
    }
}
