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
    @IBOutlet weak var percentage: UILabel!
    var contentURL: URL!
    var s3Url: URL!
    
    @IBOutlet weak var displayImage: UIImageView!
    let baseURL = "http://142.93.198.134:5000/"
//    let baseURL = "http://192.168.1.162:5000/"
    
    
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
        let nametoUpload = birdSounds[myIndex]
        uploadFile(with: nametoUpload, type: "wav")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        titleLabel.text = birdSounds[myIndex]
        self.titleLabel?.text = ""
        self.percentage?.text = ""
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
        
        let request = AWSS3TransferManagerUploadRequest()!
        request.bucket = self.bucketName
        request.key = key
        request.body = localImageUrl
        request.acl = .publicReadWrite
        let res = self.s3Url.appendingPathComponent(self.bucketName).appendingPathComponent(key)
        self.contentURL = res
        print("\(self.contentURL!)")
        
        Alamofire.request(self.baseURL + "exists/\(self.contentURL!)").responseString { response in
            print("Success: \(response.result.isSuccess)")
            if (response.result.isSuccess) {
                print(" does exist: \(response.result.value!)")
                if ("\(response.result.value!)" == "true") {
                    print("Response was true")
                    Alamofire.request(self.baseURL + "classify/\(self.contentURL!)").responseString { response in
                        print("Success: \(response.result.isSuccess)")
                        var ans = ""
                        self.temp?.text = "Classifying"
                        if (response.result.isSuccess) {
                            //                print("Response String: \(response.result.value!)")
                            ans =  "\(response.result.value!)"
                            var ansArray = ans.components(separatedBy: " ")
                            self.titleLabel?.text = ansArray[0].components(separatedBy: ":")[0]
                            self.percentage?.text = ansArray[1]
                            
                            print(ansArray[0].components(separatedBy: ":")[0])
                            if (ansArray[0].components(separatedBy: ":")[0] == "Andropadus") {
                                self.displayImage?.image = UIImage(named: "AndropadusGeneric.jpg")
                            } else if (ansArray[0].components(separatedBy: ":")[0] == "Anthus") {
                                self.displayImage?.image = UIImage(named: "AnthusGeneric.jpg")
                            } else if (ansArray[0].components(separatedBy: ":")[0] == "Camaroptera") {
                                self.displayImage?.image = UIImage(named: "CamaropteraGeneric.jpg")
                            } else if (ansArray[0].components(separatedBy: ":")[0] == "Chlorophoneus") {
                                self.displayImage?.image = UIImage(named: "ChlorophonuesGeneric.jpg")
                            } else if (ansArray[0].components(separatedBy: ":")[0] == "Cossypha") {
                                self.displayImage?.image = UIImage(named: "CossyphaGeneric.jpeg")
                            }
                            
                            self.temp.text = "Done"
                            print(ans)
                        } else {
                            ans = "404 API request failed"
                        }
//
//
//                    let transferManager = AWSS3TransferManager.default()
//                    transferManager.upload(request).continueOnSuccessWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
//                        if let error = task.error {
//                            print(error)
//                        }
//                        if task.result != nil {
//                            print("Uploaded \(key)")
//                            self.temp.text = "Classifying"
//                            let res = self.s3Url.appendingPathComponent(self.bucketName).appendingPathComponent(key)
//                            self.contentURL = res
//                            print("\(self.contentURL!)")
//                            //                print(self.getClassificationFromBackend(path: "classify/\(self.contentURL!)"))
//                            var ans = ""
//                            Alamofire.request(self.baseURL + "classify/\(self.contentURL!)").responseString { response in
//                                print("Success: \(response.result.isSuccess)")
//
//                                if (response.result.isSuccess) {
//                                    //                print("Response String: \(response.result.value!)")
//                                    ans =  "\(response.result.value!)"
//                                    var ansArray = ans.components(separatedBy: " ")
//                                    self.titleLabel?.text = ansArray[0].components(separatedBy: ":")[0]
//                                    self.percentage?.text = ansArray[1]
//
//                                    print(ansArray[0].components(separatedBy: ":")[0])
//                                    if (ansArray[0].components(separatedBy: ":")[0] == "Andropadus") {
//                                        self.displayImage?.image = UIImage(named: "AndropadusGeneric.jpg")
//                                    } else if (ansArray[0].components(separatedBy: ":")[0] == "Anthus") {
//                                        self.displayImage?.image = UIImage(named: "AnthusGeneric.jpg")
//                                    } else if (ansArray[0].components(separatedBy: ":")[0] == "Camaroptera") {
//                                        self.displayImage?.image = UIImage(named: "CamaropteraGeneric.jpg")
//                                    } else if (ansArray[0].components(separatedBy: ":")[0] == "Chlorophoneus") {
//                                        self.displayImage?.image = UIImage(named: "ChlorophonuesGeneric.jpg")
//                                    } else if (ansArray[0].components(separatedBy: ":")[0] == "Cossypha") {
//                                        self.displayImage?.image = UIImage(named: "CossyphaGeneric.jpeg")
//                                    }
//
//                                    self.temp.text = "Done"
//                                    print(ans)
//                                } else {
//                                    ans = "404 API request failed"
//                                }
//                            }
//                            //                let tempANS = self.getClassificationFromBackend(path: "classify/\(self.contentURL!)")
//                            print(ans)
//                            //                self.titleLabel?.text = ans
//
//                        }
//                        return nil
//                    }
//
                    
                }
            } else {
                    print("Response was false")
                var ans = ""
                    let transferManager = AWSS3TransferManager.default()
                            transferManager.upload(request).continueOnSuccessWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
                                if let error = task.error {
                                    print(error)
                                }
                                if task.result != nil {
                                    print("Uploaded \(key)")
                                    self.temp.text = "Classifying"
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
                                            var ansArray = ans.components(separatedBy: " ")
                                            self.titleLabel?.text = ansArray[0].components(separatedBy: ":")[0]
                                            self.percentage?.text = ansArray[1]
                    
                                            print(ansArray[0].components(separatedBy: ":")[0])
                                            if (ansArray[0].components(separatedBy: ":")[0] == "Andropadus") {
                                                self.displayImage?.image = UIImage(named: "AndropadusGeneric.jpg")
                                            } else if (ansArray[0].components(separatedBy: ":")[0] == "Anthus") {
                                                self.displayImage?.image = UIImage(named: "AnthusGeneric.jpg")
                                            } else if (ansArray[0].components(separatedBy: ":")[0] == "Camaroptera") {
                                                self.displayImage?.image = UIImage(named: "CamaropteraGeneric.jpg")
                                            } else if (ansArray[0].components(separatedBy: ":")[0] == "Chlorophoneus") {
                                                self.displayImage?.image = UIImage(named: "ChlorophonuesGeneric.jpg")
                                            } else if (ansArray[0].components(separatedBy: ":")[0] == "Cossypha") {
                                                self.displayImage?.image = UIImage(named: "CossyphaGeneric.jpeg")
                                            }
                    
                                            self.temp.text = "Done"
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

        
        
//
//        let transferManager = AWSS3TransferManager.default()
//        transferManager.upload(request).continueOnSuccessWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
//            if let error = task.error {
//                print(error)
//            }
//            if task.result != nil {
//                print("Uploaded \(key)")
//                self.temp.text = "Classifying"
//                let res = self.s3Url.appendingPathComponent(self.bucketName).appendingPathComponent(key)
//                self.contentURL = res
//                print("\(self.contentURL!)")
////                print(self.getClassificationFromBackend(path: "classify/\(self.contentURL!)"))
//                var ans = ""
//                Alamofire.request(self.baseURL + "classify/\(self.contentURL!)").responseString { response in
//                    print("Success: \(response.result.isSuccess)")
//
//                    if (response.result.isSuccess) {
//                        //                print("Response String: \(response.result.value!)")
//                        ans =  "\(response.result.value!)"
//                        var ansArray = ans.components(separatedBy: " ")
//                        self.titleLabel?.text = ansArray[0].components(separatedBy: ":")[0]
//                        self.percentage?.text = ansArray[1]
//
//                        print(ansArray[0].components(separatedBy: ":")[0])
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
//                        print(ans)
//                    } else {
//                        ans = "404 API request failed"
//                    }
//                }
////                let tempANS = self.getClassificationFromBackend(path: "classify/\(self.contentURL!)")
//                print(ans)
////                self.titleLabel?.text = ans
//
//            }
//            return nil
        }
    }

    func getClassificationFromBackend(path: String) -> String
    {
        let classifyURL = self.baseURL + path
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
    

}
}
