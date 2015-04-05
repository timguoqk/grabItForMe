//
//  PostViewController.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import UIKit
import SwiftHTTP

class PostViewController: UIViewController {
    
    override init() {
        super.init(nibName: "PostView", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func buttonClick(sender: AnyObject) {
        // These code snippets use an open-source library. http://unirest.io/objective-c
      
        let params:[String:AnyObject]=["language": "english", "text": textField.text]
        var request = HTTPTask()
        //var jsonObject:[AnyObject]
        request.requestSerializer.headers["X-Mashape-Key"] = "4Kp5Ac8mCnmshn1KN93OfIFcpYzdp1YoKOnjsnIoKo4Af6mUtK"
        request.requestSerializer.headers["Content-Type"] = "application/x-www-form-urlencoded"
        request.responseSerializer = JSONResponseSerializer()
        request.POST("https://japerk-text-processing.p.mashape.com/phrases/", parameters: params, success: {(response: HTTPResponse) in if let text: AnyObject = response.responseObject {
            
            var dict = text as NSDictionary
            var loc = text["LOCATION"] as NSArray
            var str = loc[0] as NSString // location
            var good = text["NP"] as NSArray // Array of nouns

            } },failure: {(error: NSError, response: HTTPResponse?) in println("\(error)") })
        }
}