//
//  OfferClassViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/28/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import Firebase

class OfferClassViewController: UIViewController {
    @IBOutlet weak var offerClassTableView: UITableView!
    
    var category:Category?
    var subject:String?
    var subjectDescription:String?
    var hourlyPay:String?
    
    var titles = ["Category","Subject","Description","Hourly Pay"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.offerClassTableView.rowHeight = offerClassTableView.bounds.height/5
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postClass(_ sender: Any) {
        //Check Current User
        guard let uid = Auth.auth().currentUser?.uid else {
            print ("No UID")
            return
        }
        let ref = Database.database().reference(fromURL: Constants.databaseURL)
        let postRef = ref.child("posts")
        let values = ["userID": uid, "category" : category?.rawValue, "subject" : subject]
        postRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err?.localizedDescription)
                return
            }
            print("Saved user data to DB")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OfferClassViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferClassTableViewCell", for: indexPath) as! OfferClassTableViewCell
        cell.titleLabel.text = titles[indexPath.row]
        
        switch indexPath.row {
        case 0:
            if let category = category{
                cell.selectedLabel.text = category.rawValue
                cell.selectedLabel.textColor = Constants.green
            } else {
                cell.selectedLabel.text = "Add"
                cell.selectedLabel.textColor = Constants.yellow
            }
        case 1:
            if let subject = subject{
                cell.selectedLabel.text = subject
                cell.selectedLabel.textColor = Constants.green
            } else {
                cell.selectedLabel.text = "Add"
                cell.selectedLabel.textColor = Constants.yellow
            }
        case 2:
            if let subjectDescription = subjectDescription{
                cell.selectedLabel.text = subjectDescription
                cell.selectedLabel.textColor = Constants.green
            } else {
                cell.selectedLabel.text = "Add"
                cell.selectedLabel.textColor = Constants.yellow
            }
        case 3:
            if let hourlyPay = hourlyPay{
                if hourlyPay == "Free"{
                    cell.selectedLabel.text = hourlyPay
                } else {
                    cell.selectedLabel.text = "$\(hourlyPay)/hour"
                }
                cell.selectedLabel.textColor = Constants.green
            } else {
                cell.selectedLabel.text = "Add"
                cell.selectedLabel.textColor = Constants.yellow
            }
        default: break
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "SelectCategory", sender: nil)
        case 1:
            performSegue(withIdentifier: "SelectSubject", sender: nil)
        case 2:
            performSegue(withIdentifier: "SelectDescription", sender: nil)
        case 3:
            performSegue(withIdentifier: "SelectHourlyPay", sender: nil)
        default:
            break
        }
    }
    
    
}
