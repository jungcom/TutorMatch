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
    
    @IBOutlet weak var tutorCollectionView: UICollectionView!
    
    var searchController: UISearchController!
    
    var posts: [Post] = []
    var profileURLs: [String] = []
    
    //Search filter
    var filteredPosts :[Post] = []
    
    //refreshControl
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewdidload for main")
        setupUI()
        
        //Retain Search results
        retrievePosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillappear for main")
        
        //Show tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupUI(){
        
        //Set Search delegate
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        //Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(retrievePosts), for: .valueChanged)
        tutorCollectionView.addSubview(refreshControl)
        
        //Add Constraints
        tutorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tutorCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tutorCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tutorCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tutorCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    @objc func retrievePosts(){
        posts = []
        filteredPosts = []
        let ref = Database.database().reference(fromURL: Constants.databaseURL).child("posts")
        
        // add filter for only not booked classes
        let query = ref.queryOrdered(byChild: "booked").queryEqual(toValue: "No")
        
        //get the posted data
        
        query.observe(.childAdded, with: { (snapshot) in
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
        
        query.observe(.childChanged, with: { (snapshot) in
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
        
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        //Present the search
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
                }
            }
        }
    }
    

}
