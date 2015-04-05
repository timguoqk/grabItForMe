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
    var lmPath: String!
    var dicPath: String!
    var currentWord: String!
    var openEarsEventsObserver: OEEventsObserver!
    let words = ["I", "WANT", "TO", "BUY", "APPLES", "AT", "RALPHS", "AM", "DESPERATE", "FOR", "COOKIES", "FROM", "DIDDY", "RIESE"];
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
        loadOpenEars()
        startListening()
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
        request.requestSerializer.headers["X-Mashape-Key"] = "4Kp5Ac8mCnmshn1KN93OfIFcpYzdp1YoKOnjsnIoKo4Af6mUtK"
        request.requestSerializer.headers["Content-Type"] = "application/x-www-form-urlencoded"
        request.responseSerializer = JSONResponseSerializer()
        request.POST("https://japerk-text-processing.p.mashape.com/phrases/", parameters: params, success: {(response: HTTPResponse) in if let text: AnyObject = response.responseObject {
            var result = [String]()
            var dict: NSDictionary = text as NSDictionary
            if dict.count != 0 {
                if dict.objectForKey("LOCATION") != nil {
                    var loc = dict["LOCATION"] as NSArray
                    var str = loc[0] as NSString // location
                    result.append(str)
                }
                else {
                    result.append(" ")
                }
                if dict.objectForKey("NP") != nil {
                    var good = text["NP"] as NSArray // Array of nouns
                    var str = good[2] as NSString
                    result.append(str)
                }
                else {
                    result.append(" ")
                }
                
            }
            completion(result: result)
            } },failure: {(error: NSError, response: HTTPResponse?) in println("\(error)") })
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
    
    //OpenEars methods begin
    
    func loadOpenEars() {
        self.openEarsEventsObserver = OEEventsObserver()
        self.openEarsEventsObserver.delegate = self
        
        var lmGenerator: OELanguageModelGenerator = OELanguageModelGenerator()
        
        var name = "LanguageModelFileStarSaver"
        lmGenerator.generateLanguageModelFromArray(words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
        
        lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(name)
        dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(name)
    }
    
    func pocketsphinxDidReceiveHypothesis(hypothesis: NSString, recognitionScore: NSString, utteranceID: NSString) {
        println("The received hypothesis is \(hypothesis) with a score of \(recognitionScore) and an ID of \(utteranceID)")
        analyzeText(hypothesis, completion: {(result) in
            println("\(result)")
        })
    }
    
    func pocketsphinxDidStartListening() {
        println("Pocketsphinx is now listening.")
    }
    
    func pocketsphinxDidDetectSpeech() {
        println("Pocketsphinx has detected speech.")
    }
    
    func pocketsphinxDidDetectFinishedSpeech() {
        println("Pocketsphinx has detected a period of silence, concluding an utterance.")
    }
    
    func pocketsphinxDidStopListening() {
        println("Pocketsphinx has stopped listening.")
    }
    
    func pocketsphinxDidSuspendRecognition() {
        println("Pocketsphinx has suspended recognition.")
    }
    
    func pocketsphinxDidResumeRecognition() {
        println("Pocketsphinx has resumed recognition.")
    }
    
    func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String, newDictionaryPathAsString: String) {
        println("Pocketsphinx is now using the following language model: \(newLanguageModelPathAsString) and the following dictionary: \(newDictionaryPathAsString)")
    }
    
    func pocketSphinxContinuousSetupDidFailWithReason(reasonForFailure: String) {
        println("Listening setup wasn't successful and returned the failure reason: \(reasonForFailure)")
    }
    
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String) {
        println("Listening teardown wasn't successful and returned the failure reason: \(reasonForFailure)")
    }
    
    func testRecognitionCompleted() {
        println("A test file that was submitted for recognition is now complete.")
    }
    
    func startListening() {
        OEPocketsphinxController.sharedInstance().setActive(true, error: nil)
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false)
    }
    
    func stopListening() {
        OEPocketsphinxController.sharedInstance().stopListening()
    }
    //OpenEars methods end
}