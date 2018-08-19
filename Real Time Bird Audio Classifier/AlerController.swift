//
//  AlerController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/19.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit

class AlertController {
    static func showAlert(inViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }

}
