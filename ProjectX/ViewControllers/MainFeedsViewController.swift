//
//  FeedsViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/23/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import Firebase

class MainFeedsViewController: UIViewController {
    //Database
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var tutorCollectionView: UICollectionView!
    
    var searchController: UISearchController!
    
    var category = ["All",Category.Academics.rawValue,"Sports","Tech","Art","Music"]
    
    //Mock Data
//    var subjects :[String] = []
//    var prices :[String] = []
//    var usernames :[String] = []
//    var subjectDescriptions : [String] = []
    var posts: [Post] = []
    
    //Search filter
    var filteredPosts :[Post] = []
    
    //refreshControl
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewdidload for main")
        
        //Set Search delegate
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        //Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(retrievePosts), for: .valueChanged)
        tutorCollectionView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillappear for main")
        
        //Retain Search results
        retrievePosts()
    }
    
    @objc func retrievePosts(){
        posts = []
        filteredPosts = []
        let ref = Database.database().reference(fromURL: Constants.databaseURL).child("posts")
        
        // add filter for only not booked classes
        let query = ref.queryOrdered(byChild: "booked").queryEqual(toValue: "No")
        
        //get the posted data
        query.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            print(snapshot.key)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let post = Post()
                post.setValuesForKeys(dictionary)
                self.posts.append(post)
                self.filteredPosts.append(post)
                
                //reload Collectionview
                DispatchQueue.main.async {
                    self.tutorCollectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }, withCancel: nil)
        
        
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        // Make this class the delegate and present the search
        present(searchController, animated: true, completion: nil)
    }
    
    //Change the booked status
    func changeBookStatus(_ post:Post){
        if let userID = Auth.auth().currentUser?.uid{
            if let uid = post.uid{
                let ref = Database.database().reference(fromURL: Constants.databaseURL).child("posts").child(uid)
                let value = ["booked" : userID]
                ref.updateChildValues(value) { (error, reference) in
                    if error != nil {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    print("Successfully updated post's booked status to database.")
                    DispatchQueue.main.async {
                        self.tutorCollectionView.reloadData()
                    }
                    // go to message view controller
                    print("msgview")
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension MainFeedsViewController : UICollectionViewDelegate, UICollectionViewDataSource,UISearchResultsUpdating {
    
    //Search Function
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredPosts = searchText.isEmpty ? posts : posts.filter({
                $0.subject?.lowercased().contains(searchText.lowercased()) ?? true
                || $0.subjectDescription?.lowercased().contains(searchText.lowercased()) ?? true
            })
            tutorCollectionView.reloadData()
        }
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.tutorCollectionView){
            return filteredPosts.count
        } else {
            return category.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.tutorCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorCollectionViewCell", for: indexPath) as! TutorCollectionViewCell
            //cell.profilePic.image = UIImage(named: profilePic[indexPath.row])
            cell.post = filteredPosts[indexPath.row]
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            cell.categoryLabel.text = category[indexPath.row]
            return cell
        }
    }
    
    //When cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //change color
        if(collectionView == self.categoryCollectionView){
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
            cell.backgroundColor = UIColor(red: 148/255, green: 55/255, blue: 255/255, alpha: 1)
        } else {
            //create an alertview saying whether you actually want to book
            let alert = UIAlertController(title: "Book Class", message: "Are you sure you want to book this class?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Yes", style: .default){ (action) in
                //MARK: TODO - move to message chat segue + change the post's status to booked
                print("hi")
                self.changeBookStatus(self.filteredPosts[indexPath.row])
            }
            let confirm = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(confirm)
            present(alert, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(collectionView == self.categoryCollectionView){
            guard var cell = collectionView.cellForItem(at: indexPath) else {
                return
            }
            cell = cell as! CategoryCollectionViewCell
            cell.backgroundColor = UIColor.white
        }
    }
    
}
