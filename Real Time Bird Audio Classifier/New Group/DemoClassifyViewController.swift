//
//  DemoClassifyViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/26.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import MapKit
import CoreLocation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


class DemoClassifyViewController: UIViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    let uuid = UUID().uuidString
    var unknownURL: URL!
    var contentURL: URL!
    let baseURL = "http://142.93.198.134:5000/"
    var player = AVAudioPlayer()
    let newPin = MKPointAnnotation()
    var ref: DatabaseReference!
    var dbUserID = ""
    var dbFileURL = ""
    var dbBird = ""
    var dbConfidence = ""
    var dbLatitude = ""
    var dbLongitude = ""
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var playbtn: UIButton!
    @IBOutlet weak var stopbtn: UIButton!
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var birdNameLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    let baseFirebaseStorageURL = "gs://badclassifier.appspot.com/demoSounds/"
    let storageRef = Storage.storage().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playbtn.layer.cornerRadius = 10
        playbtn.clipsToBounds = true
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        stopbtn.layer.cornerRadius = 10
        stopbtn.clipsToBounds = true
        self.birdNameLabel?.text = ""
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: demoSounds[demoIndex], ofType: "mp3")!) )
            player.prepareToPlay()
        } catch {
            print(error)
        }
        uploadFileMain()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    @IBAction func playSound(_ sender: Any) {
        player.play()
    }
    
    @IBAction func stopSound(_ sender: Any) {
        player.stop()
    }
    //    @IBOutlet weak var playSound: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadFileMain() {
        
        let localImageUrl = URL.init(fileURLWithPath: Bundle.main.path(forResource: demoSounds[demoIndex], ofType: "mp3")!)
        print("localWhat: \(localImageUrl)")
        let localFile = URL(string: "\(localImageUrl)")
        let riversRef = storageRef.child("demoSounds/" + demoSounds[demoIndex] + ".mp3")
        let uploadTask = riversRef.putFile(from: localFile!, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
//            let size = metadata.size
            // You can also access to download URL after upload.
            self.storageRef.downloadURL { (url, error) in
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            print("SALAH")
            let starsRef = self.storageRef.child("demoSounds/" + demoSounds[demoIndex] + ".mp3")
            starsRef.downloadURL { url, error in
                if error != nil {
                    // Handle any errors
                } else {
                    print("MUTHA \(url!)")
                    let parameters: Parameters = [
                        "url": "\(url!)"
                    ]
                    
                    print("\(self.baseURL)classifyPost")
                    Alamofire.request("\(self.baseURL)classifyPost", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
                        print("Success: \(response.result.isSuccess)")
                        print("Success: \(response.result.isSuccess)")
                        var ans = ""
                        if (response.result.isSuccess) {
                            //                print("Response String: \(response.result.value!)")
                            ans =  "\(response.result.value!)"
                            var ansArray = ans.components(separatedBy: " ")
                            self.birdNameLabel?.text = self.getRealName(genus: ansArray[0].components(separatedBy: ":")[0]) + " " + ansArray[1]
                            self.setPic(genus: ansArray[0].components(separatedBy: ":")[0])
                            
                            
                            //                            self.birdPercentageLabel?.text = ansArray[1]
                            print(ansArray[0].components(separatedBy: ":")[0])
                            
                            self.activityIndicator.stopAnimating()
                            
                            let user = Auth.auth().currentUser
                            self.dbUserID =  user!.uid
                            self.dbFileURL = "\(url!)"
                            self.dbBird = ansArray[0].components(separatedBy: ":")[0]
                            self.dbConfidence = ansArray[1]
                        } else {
                            ans = "404 API request failed"
                        }
                    }
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        dbLatitude = "\(location.coordinate.latitude)"
        dbLongitude = "\(location.coordinate.longitude)"
        //        print("latitude: \(location.coordinate.latitude)")
        //        print("longitude: \(location.coordinate.longitude)")
        map.setRegion(region, animated: false)
        //                self.map.showsUserLocation = true
        newPin.coordinate = myLocation
        map.addAnnotation(newPin)
    }
    
    func setPic(genus: String){
        switch genus {
        case "Andropadus":
            self.displayImage?.image = UIImage(named: "AndropadusGeneric.jpg")
        case "Anthus":
            self.displayImage?.image = UIImage(named: "AnthusGeneric.jpg")
        case "Camaroptera":
            self.displayImage?.image = UIImage(named: "CamaropteraGeneric.jpg")
        case "Cercotrichas":
            self.displayImage?.image = UIImage(named: "Cercotrichas.jpg")
        case "Chlorophoneus":
            self.displayImage?.image = UIImage(named: "ChlorophonuesGeneric.jpg")
        case "Cossypha":
            self.displayImage?.image = UIImage(named: "CossyphaGeneric.jpeg")
        case "Laniarius":
            self.displayImage?.image = UIImage(named: "Laniarius.jpg")
        case "Prinia":
            self.displayImage?.image = UIImage(named: "Prinia.jpg")
        case "Sylvia":
            self.displayImage?.image = UIImage(named: "Sylvia.jpg")
        case "Telophorus":
            self.displayImage?.image = UIImage(named: "Telophorus.jpg")
        default:
            print("NO MATCH")
        }
        }
    
        func getRealName(genus: String) -> String {
            switch genus {
            case "Andropadus":
                return "Sombre GreenBul"
            case "Anthus":
                return "African Rock Pipit"
            case "Camaroptera":
                return "Green Backed Camaroptera"
            case "Cercotrichas":
                return "White Browed Scrub Robin"
            case "Chlorophoneus":
                return "Olive Bushshrike"
            case "Cossypha":
                return "Cape Robin Chat"
            case "Laniarius":
                return "Southern Boubou"
            case "Prinia":
                return "Karoo Prinia"
            case "Sylvia":
                return "Chestnut Vented Warbler"
            case "Telophorus":
                return "Bokmakierie"
            default:
                return genus
            }
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
