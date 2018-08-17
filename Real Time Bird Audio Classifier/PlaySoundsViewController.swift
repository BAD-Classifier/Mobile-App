//
//  PlaySoundsViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/06.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipMunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
        
    }
    
    
    @IBAction func playSoundForButton(_ sender: UIButton){
//        switch(ButtonType(rawValue: sender.tag)!) {
//        case .slow:
//            playSound(rate: 0.5)
//        case .fast:
//            playSound(rate: 1.5)
//        case .chipmunk:
//            playSound(pitch: 1000)
//        case .vader:
//            playSound(pitch: -1000)
//        case .echo:
//            playSound(echo: true)
//        case .reverb:
//            playSound()
//        }
//
//        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject){
//        stopAudio()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupAudio()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        configureUI(.notPlaying)
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
