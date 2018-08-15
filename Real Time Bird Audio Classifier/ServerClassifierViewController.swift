//
//  ServerClassifierViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/15.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import AVFoundation
import AWSCognito
import AWSS3
import Alamofire

class ServerClassifierViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var temp: UILabel!
    var contentURL: URL!
    var s3Url: URL!
    
    let baseURL = "http://142.93.198.134:5000/"
    
    
    let bucketName = "birdcalls"
    var player = AVAudioPlayer()
    
    @IBAction func playSound(_ sender: Any) {
        player.play()
    }
    @IBAction func pauseSound(_ sender: Any) {
        if player.isPlaying {
            player.pause()
        }
    }
    @IBAction func upload(_ sender: Any) {
        temp.text = "Uploading"
        var nametoUpload = birdSounds[myIndex]
        uploadFile(with: nametoUpload, type: "wav")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = birdSounds[myIndex]
        let name = birdSounds[myIndex]
        temp.text = ""
        
//        Alamofire.request(baseURL).responseString { response in
//            print("Success: \(response.result.isSuccess)")
//            print("Response String: \(response.result.value!)")
//        }
//        print("The GOAT")
//        print(getClassificationFromBackend(path: ""))
        
        do{

            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "wav")!) )
            player.prepareToPlay()
        } catch {
            print(error)
        }
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:7909852c-1c61-4975-92d3-c26a5d5bc184")
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        s3Url = AWSS3.default().configuration.endpoint.url
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadFile(with resource: String, type: String) {
        let key = "\(resource).\(type)"
        print(key)
        let localImagePath = Bundle.main.path(forResource: resource, ofType: type)!
        let localImageUrl = URL(fileURLWithPath: localImagePath)
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
                let res = self.s3Url.appendingPathComponent(self.bucketName).appendingPathComponent(key)
                self.contentURL = res
                print("\(self.contentURL!)")
//                print(self.getClassificationFromBackend(path: "classify/\(self.contentURL!)"))
                var ans = ""
                Alamofire.request(self.baseURL + "classify/\(self.contentURL!)").responseString { response in
                    print("Success: \(response.result.isSuccess)")
                    
                    if (response.result.isSuccess) {
                        //                print("Response String: \(response.result.value!)")
                        ans =  "\(response.result.value!)"
                        self.titleLabel?.text = "\(response.result.value!)"
                        print(ans)
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

    func getClassificationFromBackend(path: String) -> String
    {
        let classifyURL = baseURL + path
        print(classifyURL)
        var ans = ""
        Alamofire.request(classifyURL).responseString { response in
            print("Success: \(response.result.isSuccess)")
            
            if (response.result.isSuccess) {
//                print("Response String: \(response.result.value!)")
                ans =  "\(response.result.value!)"
                print(ans)
            } else {
                ans = "404 API request failed"
            }
        }
    
        return ans
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
