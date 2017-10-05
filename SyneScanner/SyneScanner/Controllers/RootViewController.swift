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
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnScanDocument.layer.borderWidth = 1
        btnScanDocument.layer.cornerRadius = 22
        btnScanDocument.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
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
