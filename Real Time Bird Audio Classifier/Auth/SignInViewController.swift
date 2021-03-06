//
//  SignInViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/19.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController, UIApplicationDelegate {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func signIn(_ sender: Any) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        guard let email = emailTF.text,
        email != "",
        let password = passwordTF.text,
        password != ""
            else {
                AlertController.showAlert(inViewController: self, title: "Missing Info", message: "Please fill out all required fields")
                activityIndicator.stopAnimating()
                return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { user, error in
            if error == nil && user != nil {
                print("Signed In")
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            } else {
                AlertController.showAlert(inViewController: self, title: "Error", message: error!.localizedDescription)
            }
        })
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        signinButton.layer.cornerRadius = 10
        signinButton.clipsToBounds = true
        
        signupButton.layer.cornerRadius = 10
        signupButton.clipsToBounds = true
        
        

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
