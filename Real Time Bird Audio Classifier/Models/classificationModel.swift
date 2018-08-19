//
//  classificationModel.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/19.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import Foundation

class classificationModel {
    var uid:String
    var username:String
    var soundURL:URL
    var bird:String
    var confidence:Double
    var latitude:Double
    var longitude:Double
    
    init(uid:String, username:String, soundURL:URL, bird:String, confidence: Double, latitude: Double, longitude:Double) {
        self.uid = uid
        self.username = username
        self.soundURL = soundURL
        self.bird = bird
        self.confidence = confidence
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
