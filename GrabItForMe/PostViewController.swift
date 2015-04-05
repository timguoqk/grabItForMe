//
//  PostViewController.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import UIKit
import SwiftHTTP

class PostViewController: UIViewController, OEEventsObserverDelegate {
    let words = ["I", "WANT", "TO", "BUY", "APPLES", "AT", "RALPHS"];
    let lmfName = "lmfName"
    var openEarsObserver = OEEventsObserver()
    
    override init() {
        super.init(nibName: "PostView", bundle: nil)
        openEarsObserver.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(analyzeText("I am desperate for cookies from Diddy Riese!"))
    }
    
    @IBOutlet weak var textField: UITextField!
    
    func analyzeText(input: String) -> [String]{
        // These code snippets use an open-source library. http://unirest.io/objective-c
      
        let params:[String:AnyObject]=["language": "english", "text": input]
        var request = HTTPTask()
        var result = [String]()
        //var jsonObject:[AnyObject]
        request.requestSerializer.headers["X-Mashape-Key"] = "4Kp5Ac8mCnmshn1KN93OfIFcpYzdp1YoKOnjsnIoKo4Af6mUtK"
        request.requestSerializer.headers["Content-Type"] = "application/x-www-form-urlencoded"
        request.responseSerializer = JSONResponseSerializer()
        request.POST("https://japerk-text-processing.p.mashape.com/phrases/", parameters: params, success: {(response: HTTPResponse) in if let json: AnyObject = response.responseObject { println("\(json)") } },failure: {(error: NSError, response: HTTPResponse?) in println("\(error)") })
        }

    func initOE() {
        var lmGenerator = OELanguageModelGenerator()
        
        let err = lmGenerator.generateLanguageModelFromArray(words, withFilesNamed: "lmfName", forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
        if err != nil {
            NSLog("Error: err.localizedDescription")
        }
        let lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName("lmfName")
        let dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName("lmfName")
        
        OEPocketsphinxController.sharedInstance().setActive(true, error: nil)
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(lmPath, dictionaryAtPath: dicPath, acousticModelAtPath:"AcousticModelEnglish" , languageModelIsJSGF: false)
    }
    
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        NSLog("The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    }
}