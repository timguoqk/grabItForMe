//
//  DeliverViewController.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import UIKit

class DeliverViewController: UIViewController {
    
    override init() {
        super.init(nibName: "DeliverView", bundle: nil)
        
        navigationItem.title = "Deliver"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Buy", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("gotoBuy"))
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func gotoBuy() {
        var bvc = BuyMapViewController()
//        self.presentViewController(bvc, animated: true, completion: nil)
        navigationController?.pushViewController(bvc, animated: true)
    }
}
