//
//  RootViewController.swift
//  CounterQuoteAgentApp
//
//  Created by Markel on 01/11/17.
//  Copyright © 2017 Markel. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

     //MARK: Properties
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var documentView: UIView!
    @IBOutlet weak var camerView: UIView!
    var callVc:VideoCallViewController?
    var galleryVc:ImagePreviewController?
    var formVc:QuoteFormViewController?
    var chatVc:ChatViewController?

    
    @IBOutlet weak var segmentControl: UISegmentedControl!

     //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialView()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Initial set up
    func loadInitialView()
    {
        callVc = self.storyboard?.instantiateViewController(withIdentifier: "videoView") as? VideoCallViewController
        callVc?.view.frame = CGRect(x: 0, y: 0, width: camerView.frame.size.width, height: camerView.frame.size.height / 2)
        camerView.addSubview((callVc?.view)!)
        
        chatVc = self.storyboard?.instantiateViewController(withIdentifier: "Chat") as? ChatViewController
        chatVc?.view.frame = CGRect(x: 0, y: camerView.frame.size.height / 2, width: camerView.frame.size.width, height: camerView.frame.size.height / 2)
        camerView.addSubview((chatVc?.view)!)
        self.addChildViewController(chatVc!)
        galleryVc = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewController") as? ImagePreviewController
        galleryVc?.view.frame = CGRect(x: 0, y: 0, width: centerView.frame.size.width, height: centerView.frame.size.height)
        centerView.addSubview((galleryVc?.view)!)
        
        formVc = self.storyboard?.instantiateViewController(withIdentifier: "documentView") as? QuoteFormViewController
        formVc?.view.frame = CGRect(x: 0, y: 0, width: centerView.frame.size.width, height: centerView.frame.size.height)
        centerView.addSubview((formVc?.view)!)

        formVc?.view.isHidden = true
        
    }

     //MARK: Button Actions
    @IBAction func segmentControlClicked()
    {
        if segmentControl.selectedSegmentIndex == 0 {
            galleryVc?.view.isHidden = false
            formVc?.view.isHidden = true

        }
        else
        {
            galleryVc?.view.isHidden = true
            formVc?.view.isHidden = false

        }
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
