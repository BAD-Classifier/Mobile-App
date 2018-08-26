//
//  DemoTableViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/25.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

var demoSounds = ["Andropadus-1",
                  "Andropadus-2",
                  "Andropadus-3",
                  "Anthus-1",
                  "Anthus-2",
                  "Anthus-3",
                  "Camaroptera-1",
                  "Camaroptera-2",
                  "Camaroptera-3",
                  "Cercotrichas-1",
                  "Cercotrichas-2",
                  "Cercotrichas-3",
                  "Cossypha-1",
                  "Laniarius-1",
                  "Laniarius-2",
                  "Laniarius-3",
                  "Prinia-1",
                  "Prinia-2",
                  "Prinia-3",
                  "Sylvia-1",
                  "Sylvia-2",
                  "Telophorus-1",
                  "Telophorus-2",
                ]
var demoIndex = 0

class DemoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoSounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoCell", for: indexPath)
        
        cell.textLabel?.text = getRealName(genus1: demoSounds[indexPath.row])
//        cell.detailTextLabel?.text = posts[indexPath.row].confidence

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        demoIndex = indexPath.row
        performSegue(withIdentifier: "demoSegue", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getRealName(genus1: String) -> String {
        let suffix = genus1.suffix(2)
        let genus = genus1.dropLast(2)
        switch genus {
        case "Andropadus":
            return ("Sombre GreenBul" + suffix)
        case "Anthus":
            return "African Rock Pipit" + suffix
        case "Camaroptera":
            return "Green Backed Camaroptera" + suffix
        case "Cercotrichas":
            return "White Browed Scrub Robin" + suffix
        case "Chlorophoneus":
            return "Olive Bushshrike" + suffix
        case "Cossypha":
            return "Cape Robin Chat" + suffix
        case "Laniarius":
            return "Southern Boubou" + suffix
        case "Prinia":
            return "Karoo Prinia" + suffix
        case "Sylvia":
            return "Chestnut Vented Warbler" + suffix
        case "Telophorus":
            return "Bokmakierie" + suffix
        default:
            return genus1
        }
    }

}
