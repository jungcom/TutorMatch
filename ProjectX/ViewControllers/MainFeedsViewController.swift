//
//  FeedsViewController.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/23/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class MainFeedsViewController: UIViewController {
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var tutorCollectionView: UICollectionView!
    
    var category = ["All","Music","Sports","Academic","Cooking","Art"]
    
    //Mock Data
    var profilePic = ["mockPerson","profile1","profile2","profile3"]
    var course = ["Acoustic Guitar","Baking","IOS Development","Spray Painting"]
    var price = ["$10/hour","Free","$20/hour","Free"]
    var names = ["Bob","Jack","Chris","Mary",]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension MainFeedsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.tutorCollectionView){
            return 4
        } else {
            return category.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.tutorCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorCollectionViewCell", for: indexPath) as! TutorCollectionViewCell
            cell.profilePic.image = UIImage(named: profilePic[indexPath.row])
            cell.courseName.text = course[indexPath.row]
            cell.distance.text = price[indexPath.row]
            cell.tutorName.text = names[indexPath.row]
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
