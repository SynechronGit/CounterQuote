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
    
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configurUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    // MARK: - Configure UI
    func configurUI()
    {
        lblNote.alpha = 0
        searchImageVIew.alpha = 0
    }
    func startAnimation()
    {
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
                    Timer.scheduledTimer(timeInterval: 5,
                                         target: self,
                                         selector: #selector(self.pushToQuoteVc),
                                         userInfo: nil,
                                         repeats: false)
                })
            })
        })
    }

    func addSearchAnimation() {
        searchImageVIew.loadGif(name: "Search_animation")
    }
    
    func pushToQuoteVc() {
        self.performSegue(withIdentifier: "NavToQuoteVc", sender: nil)
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

//MARK: - GetOCRProxyDelgate methods
extension LoaderViewController:GetOCRProxyDelgate
{
    // Start OCR service
    func startOCR() {
        let getOCRproxy =  GetOCRProxy()
        getOCRproxy.delegate = self
        getOCRproxy.callGetOCRApi(corelationId: SharedData.sharedInstance.corelationId)
    }
    
    func getOCRSuccess(responseData:[String:AnyObject]) {
        pushToQuoteVc()
    }
    
    func getOCRFailed(errorMessage:String) {
        pushToQuoteVc()
    }
}
