//
//  SignUpViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/19.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UIApplicationDelegate {


    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBAction func signUp(_ sender: Any) {
        guard let username = usernameTF.text,
            username != "",
            let email = emailTF.text,
            email != "",
            let password = passwordTF.text,
            password != ""
            else {
                AlertController.showAlert(inViewController: self, title: "Missing Info", message: "Please fill out all fields")
                return }
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            if error == nil && user != nil {
                print("User created")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges(completion: {(error ) in
                    guard error == nil else {
                        AlertController.showAlert(inViewController: self, title: "Error", message: error!.localizedDescription)
                        return
                    }
                    self.performSegue(withIdentifier: "signUpSegue", sender: nil)
                })
                
//                print(user?.uid)
            } else {
                AlertController.showAlert(inViewController: self, title: "Error", message: error!.localizedDescription)
            }
            
            guard error == nil else {
                AlertController.showAlert(inViewController: self, title: "Error", message: error!.localizedDescription)
                return
            }
//            guard let user = user else {return}
//            print(user.email ?? "MISSING EMAIL")
//            print(user.uid)
//
//            let changeRequest = user.profile
        }
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

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
