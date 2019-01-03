//
//  CollectionViewDelegateFunctions.swift
//  ProjectX
//
//  Created by Anthony Lee on 1/2/19.
//  Copyright © 2019 projectX. All rights reserved.
//

//CollectionView Delegates
import UIKit

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
        return filteredPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorCollectionViewCell", for: indexPath) as! TutorCollectionViewCell
        //cell.profilePic.image = UIImage(named: profilePic[indexPath.row])
        cell.post = filteredPosts[indexPath.row]
        return cell
    }
    
    //When cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //create an alertview saying whether you actually want to book
        let alert = UIAlertController(title: "Book Class", message: "Are you sure you want to book this class?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Yes", style: .default){ (action) in
            //MARK: TODO - move to message chat segue + change the post's status to booked
            self.changeBookStatus(self.filteredPosts[indexPath.row])
            self.showChatLog(self.filteredPosts[indexPath.row])
        }
        let confirm = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    
    func showChatLog(_ post:Post){
        let chatlogVC = ChatLogViewController(collectionViewLayout:UICollectionViewFlowLayout())
        chatlogVC.post = post
        self.navigationController?.pushViewController(chatlogVC, animated: true)
    }
}
