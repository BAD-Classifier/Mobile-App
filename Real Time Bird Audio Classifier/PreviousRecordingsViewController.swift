//
//  PreviousRecordingsViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/20.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PreviousRecordingsViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var posts = [classificationModel]()
    var tests = ["fuck", "you"]
    var ref: DatabaseReference!
    
    @IBAction func refreshTable(_ sender: Any) {
        let user = Auth.auth().currentUser
        if let user = user {
            _ = user.uid
        }
        //        print(user?.uid as Any)
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        //        print("USERID: \(String(describing: userID))")
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for temp in value!{
                //                print("value: \(temp.value)")
                let res = temp.value as? NSDictionary
                //                print("res: \(String(describing: res!["bird"]))")
                if ("\(String(describing: res!["bird"]))" == user!.uid){
                    let tempPost = classificationModel(uid: "\(String(describing: res!["bird"]))", soundURL: "\(String(describing: res!["fileURL"]))", bird: "\(String(describing: res!["bird"]))", confidence: "\(String(describing: res!["confidence"]))", latitude: 0, longitude: 0)
                    self.posts.append(tempPost)
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        posts.removeAll()
        let user = Auth.auth().currentUser
        if let user = user {
            _ = user.uid
        }
        //        print(user?.uid as Any)
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        //        print("USERID: \(String(describing: userID))")
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for temp in value!{
                //                print("value: \(temp.value)")
                let res = temp.value as? NSDictionary
                //                print("res: \(String(describing: res!["bird"]))")
                print("USER ID: \(user!.uid)")
                print("FUCK: \(String(describing: res!["uid"]!))")
                if ("\(res!["uid"]!)" == user!.uid){
                    print("TRUE: \(res!["bird"]!)")
                    let tempPost = classificationModel(uid: "\(res!["bird"]!)", soundURL: "\(res!["fileURL"]!)", bird:  "\(res!["bird"]!)", confidence:  "\(res!["confidence"]!)", latitude: 0, longitude: 0)
                    print(tempPost.bird)
                    print(tempPost.confidence)
                    self.posts.append(tempPost)
                    self.tests.append(tempPost.bird)
                    self.tableView.reloadData()
                    for temp in self.posts {
                        print(temp.bird)
                        print(temp.confidence)
                    }
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previousCell", for: indexPath)
        
        cell.textLabel?.text = posts[indexPath.row].bird
//        cell.textLabel?.text = tests[indexPath.row]
//        print("\(posts[indexPath.row].bird)")
        return cell
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
