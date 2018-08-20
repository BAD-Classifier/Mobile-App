//
//  PreviousPlaybackViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/20.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import MapKit
import CoreLocation

class PreviousPlaybackViewController: UIViewController, CLLocationManagerDelegate  {

    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var birdName: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    var player = AVAudioPlayer()
    let newPin = MKPointAnnotation()
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    let urlFileDownload = URL(string: posts[postsindex].soundURL)
    var temp5 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = 10
        playButton.clipsToBounds = true
        
        stopButton.layer.cornerRadius = 10
        stopButton.clipsToBounds = true
        
        playButton.isEnabled = false
        stopButton.isEnabled = false
        print("\(urlFileDownload!)")
        
        
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double("\(posts[postsindex].latitude)")!, Double("\(posts[postsindex].longitude)")!)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        print("\(posts[postsindex].latitude)")
        print("\(posts[postsindex].longitude)")
        //        print("latitude: \(location.coordinate.latitude)")
        //        print("longitude: \(location.coordinate.longitude)")
        map.setRegion(region, animated: true)
        map.showsUserLocation = false
        newPin.coordinate = myLocation
        map.addAnnotation(newPin)
       
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("file.wav")
            return (documentsURL, [.removePreviousFile])
        }
        
        Alamofire.download(urlFileDownload!, to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
                print("destinationUrl \(destinationUrl.absoluteURL)")
                do{
                    self.player = try AVAudioPlayer(contentsOf: destinationUrl.absoluteURL)
                    self.player.prepareToPlay()
                    self.playButton.isEnabled = true
                    self.stopButton.isEnabled = true
                } catch {
                    print(error)
                }
                
            }
        }
        
       
//
        print(posts[postsindex].bird)
        birdName?.text = getRealName(genus: posts[postsindex].bird) + " " + posts[postsindex].confidence
//        percentageLabel?.text = posts[postsindex].confidence
        setPic(genus: posts[postsindex].bird)
   
        
        // Do any additional setup after loading the view.
    }
    @IBAction func playSound(_ sender: Any) {
        player.play()
    }
    
    @IBAction func stopSound(_ sender: Any) {
        player.stop()
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
