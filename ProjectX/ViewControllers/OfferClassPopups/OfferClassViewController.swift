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
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var offerClassButton: UIButton!
    
    var category:Category?
    var subject:String?
    var subjectDescription:String?
    var hourlyPay:String?
    
    var userData:User?
    
    var allSet = [false,false,false,false]
    
    var titles = ["Category","Subject","Description","Hourly Pay"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIConstraints()
        // Do any additional setup after loading the view.
        getCurrentUser()
    }
    
    func getCurrentUser(){
        if let user = Auth.auth().currentUser{
            let _ = Database.database().reference(fromURL: Constants.databaseURL).child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.userData = User()
                    self.userData?.setValuesForKeys(dictionary)
                }
            })
        } else {
            //No user selected ... go to login
            print("User not found in offeredclassviewcontroller")
        }
    }
    
    @objc func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postClass(_ sender: Any) {
        //If fields are empty, cannot post
        if allSet.contains(false){
            let alert = UIAlertController(title: "Please fill in all fields", message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true)
            return
        }
        
        // MARK: TODO - Check Current User, if doesnt exist, logout
        guard let uid = Auth.auth().currentUser?.uid else {
            print ("No UID")
            return
        }
        
        // MARK: Add post data
        let ref = Database.database().reference(fromURL: Constants.databaseURL).child("posts")
        let postRef = ref.childByAutoId()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        var values = ["user":uid , "userFirstName": userData?.firstName, "userLastName":userData?.lastName, "category" : category?.rawValue, "subject" : subject, "subjectDescription" : subjectDescription, "hourlyPay" : hourlyPay] as [String : Any]
        values["timestamp"] = timestamp
        values["booked"] = "No"
        values["uid"] = postRef.key
        postRef.setValue(values) { (error, ref) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            print("Saved user data to DB")
            self.dismiss(animated: true, completion: nil)
        }
    }
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
                allSet[0] = true
            } else {
                cell.selectedLabel.text = "Add"
                cell.selectedLabel.textColor = Constants.yellow
                allSet[0] = false
            }
        case 1:
            if let subject = subject{
                cell.selectedLabel.text = subject
                cell.selectedLabel.textColor = Constants.green
                allSet[1] = true
            } else {
                cell.selectedLabel.text = "Add"
                cell.selectedLabel.textColor = Constants.yellow
                allSet[1] = false
            }
        case 2:
            if let subjectDescription = subjectDescription{
                cell.selectedLabel.text = subjectDescription
                cell.selectedLabel.textColor = Constants.green
                allSet[2] = true
            } else {
                cell.selectedLabel.text = "Add"
                cell.selectedLabel.textColor = Constants.yellow
                allSet[2] = false
            }
        case 3:
            if let hourlyPay = hourlyPay{
                if hourlyPay == "Free"{
                    cell.selectedLabel.text = hourlyPay
                } else {
                    cell.selectedLabel.text = "$\(hourlyPay)/hour"
                }
                cell.selectedLabel.textColor = Constants.green
                allSet[3] = true
            } else {
                cell.selectedLabel.text = "Add"
                cell.selectedLabel.textColor = Constants.yellow
                allSet[3] = false
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

//Constraints
extension OfferClassViewController{
    func setupUIConstraints(){

        //create cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        
        //TableView Constraints
        offerClassTableView.translatesAutoresizingMaskIntoConstraints = false
        
        offerClassTableView.rowHeight = view.frame.height/6
        offerClassTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        offerClassTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        offerClassTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        offerClassTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        offerClassTableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor).isActive = true
        
        //bottom View Constraints
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.topAnchor.constraint(equalTo: offerClassTableView.bottomAnchor).isActive = true
        bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        //OfferClassButton constraints
        offerClassButton.translatesAutoresizingMaskIntoConstraints = false
        offerClassButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor).isActive = true
        offerClassButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor).isActive = true
        offerClassButton.widthAnchor.constraint(equalTo: bottomBar.widthAnchor, multiplier: 0.9).isActive = true
        offerClassButton.heightAnchor.constraint(equalTo: bottomBar.heightAnchor, multiplier: 0.85).isActive = true
        
    }
}
