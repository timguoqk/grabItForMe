//
//  WelcomeViewController.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import UIKit
import pop

class WelcomeViewController: UIViewController, POPAnimationDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var fbLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    
    var animationStopCount = 0
    
    override init() {
        super.init(nibName: "WelcomeView", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func fbButtonTouched(sender: AnyObject) {
        SVProgressHUD.show()
        var user = PFUser.currentUser()
        PFFacebookUtils.linkUser(user, permissions:["user_friends"], {
            (succeeded: Bool!, error: NSError!) -> Void in
            if (succeeded != nil) {
                FBRequestConnection.startForMeWithCompletionHandler({
                    (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                    
                })
                SVProgressHUD.dismiss()
                self.startAnimations()
            }
            else {
                println("HELL NO! FB!")
            }
        })
    }
    
    func startAnimations() {
        var anim1 = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
        anim1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim1.fromValue = fbLabel.layer.position.x
        anim1.toValue = -150
        anim1.duration = 0.8
        anim1.delegate = self
        
        var anim2 = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
        anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim2.fromValue = titleLabel.layer.position.x
        anim2.toValue = 600
        anim2.duration = 1
        anim2.delegate = self
        
        var anim3 = POPBasicAnimation(propertyNamed: kPOPLayerSize)
        anim3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        anim3.fromValue = NSValue(CGSize: fbButton.layer.frame.size)
        anim3.toValue = NSValue(CGSize: CGSizeMake(0, 0))
        anim3.duration = 0.6
        anim3.delegate = self
        
        var anim4 = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        anim4.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim4.fromValue = 0
        anim4.toValue = 1
        anim4.duration = 1
        anim4.delegate = self
        
        fbLabel.layer.pop_addAnimation(anim1, forKey: "pX1")
        titleLabel.layer.pop_addAnimation(anim2, forKey: "pX2")
        fbButton.layer.pop_addAnimation(anim3, forKey: "pS3")
        welcomeLabel.layer.pop_addAnimation(anim4, forKey: "pO4")
        
    }
    
    func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
        animationStopCount += 1
        if animationStopCount == 4 {
            sleep(1)
            var pvc = PostViewController()
            self.navigationController?.pushViewController(pvc, animated: true)
        }
    }
}
