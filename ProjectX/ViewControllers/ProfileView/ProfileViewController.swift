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
    var uid : String?
    var currentUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        checkIfUserIsLoggedIn()
        observeUserClasses()
        profilePicAddGesture()
    }
    
    //See if user is logged in
    func checkIfUserIsLoggedIn(){
        //logout if user is not logged in
        if Auth.auth().currentUser?.uid == nil{
            handleLogout()
        } else {
            //Get user data if user is logged in
            if let uid = Auth.auth().currentUser?.uid{
                
                self.uid = uid
                
                Database.database().reference(fromURL: Constants.databaseURL).child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        self.currentUser.setValuesForKeys(dictionary)
                        self.userName.text = self.currentUser.firstName
                        if let profileImageUrl = self.currentUser.profileImageUrl{
                            self.profilePic.loadImageUsingCacheWithUrlString(profileImageUrl)
                        }
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
        
        profilePic.layer.cornerRadius = 20
        profilePic.layer.masksToBounds = true
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

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Add imagePicker for profileView
    func profilePicAddGesture(){
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    }
    
    @objc func handleSelectProfileImageView(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePic.image = selectedImage
        }
        
        //Save this image to Firebase
        saveImageToDatabase()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveImageToDatabase(){
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        if let profileImage = self.profilePic.image, let uploadData = profileImage.jpegData(compressionQuality: 0.05){
            storageRef.putData(uploadData, metadata: nil) { (_, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    guard let url = url else { return }
                    let urlString = url.absoluteString
                    if let uid = self.uid{
                        self.updateUserProfileImageUrl(uid, urlString)
                    }
                })
            }
        }
    }
    
    //Update Firebase Database User ProfileImageUrl
    func updateUserProfileImageUrl(_ uid : String, _ url : String){
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        let values = ["profileImageUrl" : url]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}

//helper function
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
