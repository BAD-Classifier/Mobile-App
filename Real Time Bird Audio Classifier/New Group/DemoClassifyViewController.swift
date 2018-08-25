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


class DemoClassifyViewController: UIViewController {

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

}
