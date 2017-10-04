//
//  LoaderViewController.swift
//  SyneScanner
//
//  Created by Markel on 29/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class LoaderViewController: UIViewController {

    @IBOutlet var searchImageVIew: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 4,
                             target: self,
                             selector: #selector(self.pushToQuoteVc),
                             userInfo: nil,
                             repeats: false)
        addSearchAnimation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pushToQuoteVc()
    {
        self.performSegue(withIdentifier: "NavToQuoteVc", sender: nil)
    }
    
    func addSearchAnimation()
    {
        searchImageVIew.loadGif(name: "Search_animation")


        // A UIImageView with async loading
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
