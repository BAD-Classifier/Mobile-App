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

class PreviousPlaybackViewController: UIViewController {

    
    @IBOutlet weak var birdName: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    var player = AVAudioPlayer()
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    let urlFileDownload = URL(string: posts[postsindex].soundURL)
    var temp5 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false
        stopButton.isEnabled = false
        print("\(urlFileDownload!)")
        
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
                    self.stopButton.isEnabled = false
                } catch {
                    print(error)
                }
                
            }
        }
        
       
//
        print(posts[postsindex].bird)
        birdName?.text = posts[postsindex].bird
        percentageLabel?.text = posts[postsindex].confidence
   
        
        // Do any additional setup after loading the view.
    }
    @IBAction func playSound(_ sender: Any) {
        player.play()
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
