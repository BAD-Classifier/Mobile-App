//
//  PreviousRecordingsViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/20.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

var posts = [classificationModel]()
var postsindex = 0

class PreviousRecordingsViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var tests = ["fuck", "you"]
    var ref: DatabaseReference!
    
    @IBAction func refreshTable(_ sender: Any) {
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
                    let tempPost = classificationModel(uid: "\(res!["bird"]!)", soundURL: "\(res!["fileURL"]!)", bird:  "\(res!["bird"]!)", confidence:  "\(res!["confidence"]!)", latitude: "\(res!["latitude"]!)", longitude: "\(res!["longitude"]!)")
                    print(tempPost.bird)
                    print(tempPost.confidence)
                    posts.append(tempPost)
                    self.tests.append(tempPost.bird)
                    self.tableView.reloadData()
                    for temp in posts {
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
//        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
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
                    let tempPost = classificationModel(uid: "\(res!["bird"]!)", soundURL: "\(res!["fileURL"]!)", bird:  "\(res!["bird"]!)", confidence:  "\(res!["confidence"]!)", latitude: "\(res!["latitude"]!)", longitude: "\(res!["longitude"]!)")
                    print(tempPost.bird)
                    print(tempPost.confidence)
                    posts.append(tempPost)
                    self.tests.append(tempPost.bird)
                    self.tableView.reloadData()
                    for temp in posts {
                        print(temp.bird)
                        print(temp.confidence)
                    }
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previousCell", for: indexPath)
        
        cell.textLabel?.text = getRealName(genus: posts[indexPath.row].bird)
        cell.detailTextLabel?.text = posts[indexPath.row].confidence
//        cell.textLabel.subtit
//        cell.textLabel?.text = tests[indexPath.row]
//        print("\(posts[indexPath.row].bird)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        postsindex = indexPath.row
        performSegue(withIdentifier: "segue2", sender: self)
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

}
