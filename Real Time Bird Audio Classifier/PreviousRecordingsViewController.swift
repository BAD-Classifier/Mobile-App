//
//  PreviousRecordingsViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/20.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PreviousRecordingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let postsRef = Database.database().reference().child("posts")
        
        postsRef.observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot as? [String:Any] {
                    let author = dict["author"] as? [String:Any]
                    let uid = author!["uid"] as? String
                    print(uid)
                }
            }
        })
        
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
