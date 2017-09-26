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

class SplashScreenViewController: UIViewController {

    @IBOutlet var imgLogo: UIImageView!
    var duration: Double = 2.0
    open var delay: Double = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

    }
   override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    playSwingAnimation()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playSwingAnimation(_ completion: SplashAnimatableCompletion? = nil)
    {
        if let imageView = self.imgLogo{
            
            let swingForce = 0.8
            
            animateLayer({
                
                let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
                animation.values = [0, 0.3 * swingForce, -0.3 * swingForce, 0.3 * swingForce, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.duration = CFTimeInterval(self.duration/2)
                animation.isAdditive = true
                animation.repeatCount = 2
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(self.delay/3)
                imageView.layer.add(animation, forKey: "swing")
                
            }, completion: {
                self.performSegue(withIdentifier: "navToIntroVc", sender: nil)
            })
        }
    }
    func animateLayer(_ animation: SplashAnimatableExecution, completion: SplashAnimatableCompletion? = nil) {
    
    CATransaction.begin()
    if let completion = completion {
    CATransaction.setCompletionBlock { completion() }
    }
    animation()
    CATransaction.commit()
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
