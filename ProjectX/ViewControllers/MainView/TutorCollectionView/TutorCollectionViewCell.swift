//
//  TutorCollectionViewCell.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/27/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import Firebase

class TutorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subjectDescription: UITextView?
    @IBOutlet weak var subject: UITextView!
    @IBOutlet weak var hourlyPay: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tutorName: UILabel!
    
    var post:Post!{
        didSet{
            if let subjDes = post.subjectDescription{
                self.subjectDescription?.text = subjDes
            }
            
            self.subject.text = post.subject?.capitalized
            
            if let pay = post.hourlyPay{
                if pay != "Free"{
                    self.hourlyPay.text = "$\(pay)/hour"
                } else {
                    self.hourlyPay.text = "Free"
                }
            }
            
            if let fn = post.userFirstName, let ln = post.userLastName{
                let capfn = fn.capitalized
                let capln = ln.capitalized
                self.tutorName.text = "\(capfn) \(capln)"
            }
            
            if let user = post.user{
                setProfilePic(user)
            }
        }
    }
    
    func setProfilePic(_ uid: String){
        self.profilePic.image = UIImage(named: "mockPerson")
        Database.database().reference(fromURL: Constants.databaseURL).child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()
                user.setValuesForKeys(dictionary)
                if let profileImageUrl = user.profileImageUrl{
                    self.profilePic.loadImageUsingCacheWithUrlString(profileImageUrl)
                }
            }
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupConstraints()
        setupUI()
    }
    
    func setupUI(){
        //cell setup
        layer.cornerRadius = 10
        backgroundColor = Constants.lightPurple
        //profilepic setup
//        if let profilePic = profilePic{
//            profilePic.layer.cornerRadius = 15
//            profilePic.clipsToBounds = true
//        }
        profilePic.contentMode = .scaleToFill
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 4.0
        
        //subjectTitle setup
        subject.textAlignment = .center
        subject.font = UIFont.boldSystemFont(ofSize: 16)
        subject.textColor = .white
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        subject.backgroundColor = Constants.purple
        
        //tutorName setup
        tutorName.font = UIFont.boldSystemFont(ofSize: 13)
        tutorName.backgroundColor = Constants.lightPurple
        tutorName.textColor = .white
//        tutorName.textAlignment = .center
        
        //hourlyPay setup
        hourlyPay.backgroundColor = Constants.green
        hourlyPay.textAlignment = .center
        hourlyPay.textColor = .white
        hourlyPay.layer.masksToBounds = true
        hourlyPay.layer.cornerRadius = 10
        
        //subject Description setup
        subjectDescription?.backgroundColor = Constants.lightPurple
        subjectDescription?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    func setupConstraints(){
        //subjectTitle Constraints
        subject.translatesAutoresizingMaskIntoConstraints = false
        subject.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subject.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subject.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        subject.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15).isActive = true

        
        //ProfilePic Constraints
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        profilePic.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        profilePic.topAnchor.constraint(equalTo: subject.bottomAnchor, constant : 10).isActive = true
        profilePic.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        
        //tutorName Constraints
        
        tutorName.translatesAutoresizingMaskIntoConstraints = false
        tutorName.topAnchor.constraint(equalTo: subject.bottomAnchor, constant: 10).isActive = true
        tutorName.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 10).isActive = true
        tutorName.trailingAnchor.constraint(equalTo: trailingAnchor, constant:-10).isActive = true
        tutorName.heightAnchor.constraint(equalTo: profilePic.heightAnchor, multiplier: 0.45).isActive = true
        
        //hourlyPay Constraints
        
        hourlyPay.translatesAutoresizingMaskIntoConstraints = false
        hourlyPay.trailingAnchor.constraint(equalTo: trailingAnchor, constant:-10).isActive = true
        hourlyPay.heightAnchor.constraint(equalTo: tutorName.heightAnchor, multiplier: 1).isActive = true
        hourlyPay.bottomAnchor.constraint(equalTo: profilePic.bottomAnchor).isActive = true
        hourlyPay.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 10).isActive = true
        
        //Description Constraints
        subjectDescription?.translatesAutoresizingMaskIntoConstraints = false
        subjectDescription?.trailingAnchor.constraint(equalTo: hourlyPay.trailingAnchor).isActive = true
        subjectDescription?.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant:10).isActive = true
        subjectDescription?.bottomAnchor.constraint(equalTo: bottomAnchor, constant:-10).isActive = true
        subjectDescription?.leadingAnchor.constraint(equalTo: profilePic.leadingAnchor).isActive = true
    }
}
