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
    
    var category = ["All","Music","Sports","Academic","Cooking","Art"]
    
    //Mock Data
    var profilePic = ["mockPerson","profile1","profile2","profile3"]
//    var subjects :[String] = []
//    var prices :[String] = []
//    var usernames :[String] = []
//    var subjectDescriptions : [String] = []
    var posts: [Post] = []
    
    //filter
    var filteredPosts :[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set Search delegate
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        //Retain Search results
        posts = []
        retrievePosts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        //empty posts
//        posts = []
//        retrievePosts()
//
//        //Set Search delegate
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
    }
    
    func retrievePosts(){
        let ref = Database.database().reference(fromURL: Constants.databaseURL).child("posts")
        ref.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let post = Post()
                post.setValuesForKeys(dictionary)
                self.posts.append(post)
                self.filteredPosts.append(post)
                
                //reload Collectionview
                DispatchQueue.main.async {
                    self.tutorCollectionView.reloadData()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainFeedsViewController : UICollectionViewDelegate, UICollectionViewDataSource,UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredPosts = searchText.isEmpty ? posts : posts.filter({
                $0.subject?.lowercased().contains(searchText.lowercased()) ?? true
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.categoryCollectionView){
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
            cell.backgroundColor = UIColor.cyan
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(collectionView == self.categoryCollectionView){
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
            cell.backgroundColor = UIColor.white
        }
    }
}
