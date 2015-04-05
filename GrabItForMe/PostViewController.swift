//
//  PostViewController.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import UIKit
import SwiftHTTP

class PostViewController: UIViewController, OEEventsObserverDelegate, EZMicrophoneDelegate {
    let words = ["I", "WANT", "TO", "BUY", "APPLES", "AT", "RALPHS", "AM", "DESPERATE", "FOR", "COOKIES", "FROM", "DIDDY", "RIESE"];
    let lmfName = "lmfName"
    var openEarsObserver = OEEventsObserver()
    @IBOutlet weak var waveView: ZLSinusWaveView!
    
    override init() {
        super.init(nibName: "PostView", bundle: nil)
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Explore", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("gotoExplore"))
        EZMicrophone.sharedMicrophone().microphoneDelegate = self
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initOE()
        waveView.backgroundColor = UIColor.whiteColor()
        waveView.color = UIColor.blackColor()
        waveView.plotType = EZPlotType.Buffer
        waveView.shouldFill = true
        waveView.shouldMirror = true
        waveView.maxAmplitude = 0.2
        EZMicrophone.sharedMicrophone().startFetchingAudio()
        
//        analyzeText("I am desperate for cookies from Diddy Riese!", completion: {(result) in
//            println(result)
//        })
    }
    
    func analyzeText(input: String, completion: (result: [String]) -> Void){
        // These code snippets use an open-source library. http://unirest.io/objective-c
        let params:[String:AnyObject]=["language": "english", "text": input]
        var request = HTTPTask()
        var result = [String]()
        request.requestSerializer.headers["X-Mashape-Key"] = "4Kp5Ac8mCnmshn1KN93OfIFcpYzdp1YoKOnjsnIoKo4Af6mUtK"
        request.requestSerializer.headers["Content-Type"] = "application/x-www-form-urlencoded"
        request.responseSerializer = JSONResponseSerializer()
        request.POST("https://japerk-text-processing.p.mashape.com/phrases/", parameters: params, success: {(response: HTTPResponse) in if let text: AnyObject = response.responseObject {
            
            var dict = text as NSDictionary
            var loc = text["LOCATION"] as NSArray
            var str = loc[0] as NSString // location
            result.append(str)
            var good = text["NP"] as NSArray // Array of nouns
            str = good[2] as NSString
            result.append(str)
            completion(result: result)
            } },failure: {(error: NSError, response: HTTPResponse?) in println("\(error)") })
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
        openEarsObserver.delegate = self
    }
    
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        NSLog("The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    }
    
    func gotoExplore() {
        var bmvc = BuyMapViewController()
        navigationController?.pushViewController(bmvc, animated: true)
    }
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue(), {
            self.waveView.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
}