//
//  LiveClassificationViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/18.
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

class LiveClassificationViewController: UIViewController, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    let uuid = UUID().uuidString
    var unknownURL: URL!
    var contentURL: URL!
    let baseURL = "http://142.93.198.134:5000/"
    var player = AVAudioPlayer()
    let newPin = MKPointAnnotation()
    var ref: DatabaseReference!
    
    @IBOutlet weak var imageView: UIImageView!
    var dbUserID = ""
    var dbFileURL = ""
    var dbBird = ""
    var dbConfidence = ""
    var dbLatitude = ""
    var dbLongitude = ""
    
    @IBOutlet weak var saveButton: UIBarButtonItem!

    @IBAction func saveFile(_ sender: Any) {
        ref = Database.database().reference().child("posts").childByAutoId()
        
        
        let postObject = [
            "uid": dbUserID,
            "fileURL": dbFileURL,
            "bird": dbBird,
            "confidence": dbConfidence,
            "latitude": dbLatitude,
            "longitude": dbLongitude
            ] as [String:Any]
        
        self.ref.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                print("Success")
                AlertController.showAlert(inViewController: self, title: "SUCCESS", message: "You have successfully uploaded the file")
            } else {
                print(error)
            }
        })
        
    }
    let baseFirebaseStorageURL = "gs://badclassifier.appspot.com/birdSounds/"
    let storageRef = Storage.storage().reference()
    
//    let data = Data()
    
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
        saveButton.isEnabled = false
        print(unknownURL)
        self.birdNameLable?.text = ""
        do{
            player = try AVAudioPlayer(contentsOf: unknownURL!)
            player.prepareToPlay()
        } catch {
            print(error)
        }
        
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
    
    func uploadFileMain(with resource: String, type: String) {

        let localImageUrl = URL(fileURLWithPath: "\(unknownURL!)")
        let localFile = URL(string: "\(localImageUrl)")
        let riversRef = storageRef.child("birdSounds/" + self.uuid + ".wav")
        let uploadTask = riversRef.putFile(from: localFile!, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            self.storageRef.downloadURL { (url, error) in
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            let starsRef = self.storageRef.child("birdSounds/" + self.uuid + ".wav")
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
                            self.birdNameLable?.text = self.getRealName(genus: ansArray[0].components(separatedBy: ":")[0]) + " " + ansArray[1]
                            self.setPic(genus: ansArray[0].components(separatedBy: ":")[0])
                            
                            
//                            self.birdPercentageLabel?.text = ansArray[1]
                            print(ansArray[0].components(separatedBy: ":")[0])
                           
                            
                            let user = Auth.auth().currentUser
                            self.dbUserID =  user!.uid
                            self.dbFileURL = "\(url!)"
                            self.dbBird = ansArray[0].components(separatedBy: ":")[0]
                            self.dbConfidence = ansArray[1]
                            self.saveButton.isEnabled = true
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
    
    func setPic(genus: String){
        switch genus {
        case "Andropadus":
            self.imageView?.image = UIImage(named: "AndropadusGeneric.jpg")
        case "Anthus":
            self.imageView?.image = UIImage(named: "AnthusGeneric.jpg")
        case "Camaroptera":
            self.imageView?.image = UIImage(named: "CamaropteraGeneric.jpg")
        case "Cercotrichas":
            self.imageView?.image = UIImage(named: "Cercotrichas.jpg")
        case "Chlorophoneus":
            self.imageView?.image = UIImage(named: "ChlorophonuesGeneric.jpg")
        case "Cossypha":
            self.imageView?.image = UIImage(named: "CossyphaGeneric.jpeg")
        case "Laniarius":
            self.imageView?.image = UIImage(named: "Laniarius.jpg")
        case "Prinia":
            self.imageView?.image = UIImage(named: "Prinia.jpg")
        case "Sylvia":
            self.imageView?.image = UIImage(named: "Sylvia.jpg")
        case "Telophorus":
            self.imageView?.image = UIImage(named: "Telophorus.jpg")
        default:
            print("NO MATCH")
        }
        
        
    }

}
