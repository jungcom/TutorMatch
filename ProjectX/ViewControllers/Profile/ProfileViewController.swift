//
//  ProfileViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/28/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        checkIfUserIsLoggedIn()
        observeUserClasses()
    }
    
    //See if user is logged in
    func checkIfUserIsLoggedIn(){
        //logout if user is not logged in
        if Auth.auth().currentUser?.uid == nil{
            handleLogout()
        } else {
            //Get user data if user is logged in
            if let uid = Auth.auth().currentUser?.uid{
                
                Database.database().reference(fromURL: Constants.databaseURL).child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        self.userName.text = dictionary["firstName"] as? String
                    }
                })
            }
        }
    }
    
    func setupUI(){
        //Profile View background
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        backgroundImage.image = UIImage(named: "purple")
//        backgroundImage.contentMode = .scaleAspectFill
        self.profileView.backgroundColor = UIColor(patternImage: UIImage(named: "purple")!)
        
        //logoutButton
        logoutButton.layer.cornerRadius = 5
        logoutButton.clipsToBounds = true
        
        //Profile Picture
        profilePic.layer.cornerRadius = 30
//        profilePic.layer.shadowColor = UIColor.gray.cgColor
//        profilePic.layer.shadowOffset = CGSize(width: 0 ,height:1)
//        profilePic.layer.shadowOpacity = 1
//        profilePic.layer.shadowRadius = 1.0
        profilePic.clipsToBounds = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logout(_ sender: Any) {
        handleLogout()
    }
    
    func handleLogout(){
        do{
            try Auth.auth().signOut()
        } catch let error{
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func observeUserClasses(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference(fromURL: Constants.databaseURL).child("posts")
        
        // add filter for only not booked classes
        let query = ref.queryOrdered(byChild: "booked").queryEqual(toValue: uid)
        
        query.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let post = Post()
                post.setValuesForKeys(dictionary)
                self.posts.append(post)
                
                //reload Collectionview
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }, withCancel: nil)
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorCollectionViewCell", for: indexPath) as! TutorCollectionViewCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    
}
