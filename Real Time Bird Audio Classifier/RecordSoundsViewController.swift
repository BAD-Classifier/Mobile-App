//
//  RecordSoundsViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/05.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import AVFoundation
import AWSCognito
import AWSS3
import Alamofire
import Firebase

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    
    let bucketName = "birdcalls"
    let baseURL = "http://142.93.198.134:5000/"
    var contentURL: URL!
    var s3Url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            // ...
        }
        print("\(user?.uid!)")
        
        stopRecordingButton.isEnabled = false
        classificationLabel?.text = " "
        percentageLabel?.text = " "
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:7909852c-1c61-4975-92d3-c26a5d5bc184")
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        s3Url = AWSS3.default().configuration.endpoint.url
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordingButton.isEnabled = false
        
        
//         setup for the audio recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "temp.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        print("filePath: \(String(describing: filePath))")
        
        let manager = FileManager.default
        
        if manager.fileExists(atPath: "\(String(describing: filePath))") {
            print("FML")
        }
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        recordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
//        let soundURL = Bundle.main.url(forResource: "\(audioRecorder.url)", withExtension: "")
//        soundURL?.deletingPathExtension().lastPathComponent
//        print(soundURL)
        print("HEre")
        print(audioRecorder.url)
        
        var audioURL = "\(audioRecorder.url)"
        audioURL.removeLast(4)
        print(audioURL)
        
//        uploadFile(with: audioURL, type: "wav")
        
//        uploadFileMain(with: audioURL, type: "wav")
        
        
        
        
    }
//
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if flag {
//            performSegue(withIdentifier: "identifySegue", sender: audioRecorder.url)
//        } else {
//            print("Finished recording")
//        }
//
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "stopRecording" {
//            let playSoundsVC = segue.destination as! PlaySoundsViewController
//            let recordedAudioURL = sender as! URL
//            playSoundsVC.recordedAudioURL = recordedAudioURL
//        }
//    }
//
    func uploadFile(with resource: String, type: String) {
        let key = "unknownSoundUser1.\(type)"
        print(key)
//        let localImagePath = Bundle.main.path(forResource: resource, ofType: type)!
        let localImageUrl = URL(fileURLWithPath: "\(audioRecorder.url)")
        
        let request = AWSS3TransferManagerUploadRequest()!
        request.bucket = bucketName
        request.key = key
        request.body = localImageUrl
        request.acl = .publicReadWrite
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(request).continueOnSuccessWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
            if let error = task.error {
                print(error)
            }
            if task.result != nil {
                print("Uploaded \(key)")
            }
            return nil
        }
    }
    
    func extractComponentBetweenDots(inputString: String) -> String? {
        
        guard inputString.components(separatedBy: ".").count > 2  else { print("Incorrect format") ; return nil } // Otherwise not in the correct format, you caa add other tests
        
        return inputString.components(separatedBy: ".")[inputString.components(separatedBy: ".").count - 2]
    }
    
    func uploadFileMain(with resource: String, type: String) {
        recordingLabel.text = "Uploading"
        recordingButton.isEnabled = false
        stopRecordingButton.isEnabled = false
        
        let key = "testing2.\(type)"
        print(key)
//        let localImagePath = Bundle.main.path(forResource: resource, ofType: type)!
        let localImageUrl = URL(fileURLWithPath: "\(audioRecorder.url)")
        //        let localImageUrl = URL(fileURLWithPath: "\(audioRecorder.url)")
        
        let request = AWSS3TransferManagerUploadRequest()!
        request.bucket = bucketName
        request.key = key
        request.body = localImageUrl
        request.acl = .publicReadWrite
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(request).continueOnSuccessWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
            if let error = task.error {
                print(error)
            }
            if task.result != nil {
                print("Uploaded \(key)")
//                self.temp.text = "Classifying"
//                let res = self.s3Url.appendingPathComponent(self.bucketName).appendingPathComponent(key)
                self.contentURL = URL(string: "https://s3.amazonaws.com/birdcalls/testing2.wav")
                print("\(self.contentURL!)")
                //                print(self.getClassificationFromBackend(path: "classify/\(self.contentURL!)"))
                self.recordingLabel?.text = "Classifying"
                
                var ans = ""
                Alamofire.request(self.baseURL + "classify/\(self.contentURL!)").responseString { response in
                    print("Success: \(response.result.isSuccess)")
                    
                    if (response.result.isSuccess) {
                        //                print("Response String: \(response.result.value!)")
                        ans =  "\(response.result.value!)"
                        var ansArray = ans.components(separatedBy: " ")
//                        self.titleLabel?.text = ansArray[0].components(separatedBy: ":")[0]
//                        self.percentage?.text = ansArray[1]
                        self.classificationLabel?.text = ansArray[0].components(separatedBy: ":")[0]
                        self.percentageLabel?.text = ansArray[1]
                        print(ansArray[0].components(separatedBy: ":")[0])
//                        if (ansArray[0].components(separatedBy: ":")[0] == "Andropadus") {
//                            self.displayImage?.image = UIImage(named: "AndropadusGeneric.jpg")
//                        } else if (ansArray[0].components(separatedBy: ":")[0] == "Anthus") {
//                            self.displayImage?.image = UIImage(named: "AnthusGeneric.jpg")
//                        } else if (ansArray[0].components(separatedBy: ":")[0] == "Camaroptera") {
//                            self.displayImage?.image = UIImage(named: "CamaropteraGeneric.jpg")
//                        } else if (ansArray[0].components(separatedBy: ":")[0] == "Chlorophoneus") {
//                            self.displayImage?.image = UIImage(named: "ChlorophonuesGeneric.jpg")
//                        } else if (ansArray[0].components(separatedBy: ":")[0] == "Cossypha") {
//                            self.displayImage?.image = UIImage(named: "CossyphaGeneric.jpeg")
//                        }
//
//                        self.temp.text = "Done"
                        print(ans)
                        
                        
                        self.recordingButton.isEnabled = true
                        self.stopRecordingButton.isEnabled = true
                        self.recordingLabel?.text = "Tap to Record"
                    } else {
                        ans = "404 API request failed"
                    }
                }
                //                let tempANS = self.getClassificationFromBackend(path: "classify/\(self.contentURL!)")
                print(ans)
                //                self.titleLabel?.text = ans
                
            }
            return nil
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! LiveClassificationViewController
        receiverVC.unknownURL = audioRecorder.url
    }
    
}

