//
//  WelcomeViewController.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import UIKit
import pop

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var fbLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    
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
        
        //TODO: really login with facebook
        
        var anim1 = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
        anim1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim1.fromValue = fbLabel.layer.position.x
        anim1.toValue = -150
        anim1.duration = 0.4
        
        var anim2 = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
        anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim2.fromValue = titleLabel.layer.position.x
        anim2.toValue = 600
        anim2.duration = 0.5
        
        var anim3 = POPBasicAnimation(propertyNamed: kPOPLayerSize)
        anim3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        anim3.fromValue = NSValue(CGSize: fbButton.layer.frame.size)
        anim3.toValue = NSValue(CGSize: CGSizeMake(0, 0))
        anim3.duration = 0.3
        
        fbLabel.layer.pop_addAnimation(anim1, forKey: "pX1")
        titleLabel.layer.pop_addAnimation(anim2, forKey: "pX2")
        fbButton.layer.pop_addAnimation(anim3, forKey: "pS3")
    }
}
