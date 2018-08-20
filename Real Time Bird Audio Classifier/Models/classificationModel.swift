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
    var soundURL:String
    var bird:String
    var confidence:String
    var latitude:String
    var longitude:String
    
    init(uid:String, soundURL:String, bird:String, confidence: String, latitude: String, longitude:String) {
        self.uid = uid
        self.soundURL = soundURL
        self.bird = bird
        self.confidence = confidence
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
