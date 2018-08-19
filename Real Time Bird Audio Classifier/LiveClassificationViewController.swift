//
//  LiveClassificationViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/18.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import AVFoundation
import AWSCognito
import AWSS3
import Alamofire
import MapKit
import CoreLocation

class LiveClassificationViewController: UIViewController, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    let uuid = UUID().uuidString
    var unknownURL: URL!
    var contentURL: URL!
    var s3Url: URL!
    let baseURL = "http://142.93.198.134:5000/"
    let bucketName = "birdcalls"
    var player = AVAudioPlayer()
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var birdNameLable: UILabel!
    @IBOutlet weak var birdPercentageLabel: UILabel!
    
    @IBAction func playSound(_ sender: Any) {
        player.play()
    }
    @IBAction func stopSound(_ sender: Any) {
        player.stop()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(unknownURL)
        
        do{
            player = try AVAudioPlayer(contentsOf: unknownURL!)
            player.prepareToPlay()
        } catch {
            print(error)
        }
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:7909852c-1c61-4975-92d3-c26a5d5bc184")
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        s3Url = AWSS3.default().configuration.endpoint.url
        var stringURL = String(describing: unknownURL)
        
        stringURL.removeLast(4)
        print(stringURL)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        uploadFileMain(with: stringURL, type: "wav")
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func uploadFileMain(with resource: String, type: String) {
        let key = "\(uuid).\(type)"
        print(key)
        //        let localImagePath = Bundle.main.path(forResource: resource, ofType: type)!
        let localImageUrl = URL(fileURLWithPath: "\(unknownURL!)")
        //        let localImageUrl = URL(fileURLWithPath: "\(audioRecorder.url)")
//        print(localImageUrl)
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
                self.contentURL = URL(string: "https://s3.amazonaws.com/birdcalls/" + "\(self.uuid)" + ".wav")
                print("\(self.contentURL!)")
                //                print(self.getClassificationFromBackend(path: "classify/\(self.contentURL!)"))
                
                var ans = ""
                Alamofire.request(self.baseURL + "classify/\(self.contentURL!)").responseString { response in
                    print("Success: \(response.result.isSuccess)")
                    
                    if (response.result.isSuccess) {
                        //                print("Response String: \(response.result.value!)")
                        ans =  "\(response.result.value!)"
                        var ansArray = ans.components(separatedBy: " ")
                                                self.birdNameLable?.text = ansArray[0].components(separatedBy: ":")[0]
                                                self.birdPercentageLabel?.text = ansArray[1]
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
                        
                        //                        self.temp.text = "Done"
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        print("latitude: \(location.coordinate.latitude)")
        print("longitude: \(location.coordinate.longitude)")
                map.setRegion(region, animated: true)
        
                self.map.showsUserLocation = true
    }

}
