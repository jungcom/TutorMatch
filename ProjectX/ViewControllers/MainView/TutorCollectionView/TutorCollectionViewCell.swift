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
    
    var topContainer = UIView()
    var separatorLine = UIView()
    
    var post:Post!{
        didSet{
            if let subjDes = post.subjectDescription{
                
                self.subjectDescription?.text = "\u{2022} \(subjDes)"
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
        //cell Shadow
//        self.layoutIfNeeded()
//        contentView.layer.cornerRadius = 10
//        contentView.layer.borderWidth = 1.0
//        contentView.layer.borderColor = UIColor.clear.cgColor
//        contentView.layer.masksToBounds = true
//        
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOffset = CGSize(width:0,height: 1.0)
//        layer.shadowRadius = 10.0
//        layer.shadowOpacity = 1.0
//        layer.masksToBounds = false;
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        //top Container Setup

        
        //cell setup
        layer.cornerRadius = 10
        
        //profilePic Setup
        profilePic.contentMode = .scaleToFill
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 4.0
        
        //subjectTitle setup
        subject.textAlignment = .center
        subject.font = UIFont.boldSystemFont(ofSize: 16)
        subject.textColor = .black
        subject.isScrollEnabled = false
        subject.backgroundColor = UIColor(white: 0.0, alpha: 0)
        
        //Separator Line
        separatorLine.backgroundColor = .gray
        
        
        
        
        //tutorName setup
        tutorName.font = UIFont.systemFont(ofSize: 11)
        tutorName.textColor = .darkGray
//        tutorName.textAlignment = .center
        
        //hourlyPay setup
        hourlyPay.textAlignment = .right
        hourlyPay.layer.masksToBounds = true
        hourlyPay.layer.cornerRadius = 10
        
        //subject Description setup
        subjectDescription?.font = UIFont.systemFont(ofSize: 9, weight: .light)
        subjectDescription?.layer.cornerRadius = 10
        subjectDescription?.layer.masksToBounds = true
        subjectDescription?.textColor = .darkGray
    }
    
    func setupConstraints(){
        //top container Constraints
        
        addSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topContainer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topContainer.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        
        //subjectTitle Constraints
        topContainer.addSubview(subject)
        subject.translatesAutoresizingMaskIntoConstraints = false
        subject.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subject.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
        
        //separator line Constraints
        topContainer.addSubview(separatorLine)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        separatorLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        separatorLine.topAnchor.constraint(equalTo: subject.bottomAnchor).isActive = true
        
        //ProfilePic Constraints
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        profilePic.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35).isActive = true
        profilePic.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant : 20).isActive = true
        profilePic.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35).isActive = true
        
        //tutorName Constraints
        
        tutorName.translatesAutoresizingMaskIntoConstraints = false
        tutorName.topAnchor.constraint(equalTo: profilePic.topAnchor).isActive = true
        tutorName.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 10).isActive = true
        tutorName.trailingAnchor.constraint(equalTo: trailingAnchor, constant:-10).isActive = true
//        tutorName.heightAnchor.constraint(equalTo: profilePic.heightAnchor, multiplier: 0.45).isActive = true
        
        //hourlyPay Constraints
        
        hourlyPay.translatesAutoresizingMaskIntoConstraints = false
        hourlyPay.trailingAnchor.constraint(equalTo: trailingAnchor, constant:-10).isActive = true
        hourlyPay.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
        hourlyPay.bottomAnchor.constraint(equalTo: bottomAnchor, constant:-10).isActive = true
        hourlyPay.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        
        //Description Constraints
        subjectDescription?.translatesAutoresizingMaskIntoConstraints = false
        subjectDescription?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        subjectDescription?.topAnchor.constraint(equalTo: tutorName.bottomAnchor).isActive = true
        subjectDescription?.bottomAnchor.constraint(equalTo: bottomAnchor, constant:-10).isActive = true
        subjectDescription?.leadingAnchor.constraint(equalTo: tutorName.leadingAnchor).isActive = true
    }
    
}
