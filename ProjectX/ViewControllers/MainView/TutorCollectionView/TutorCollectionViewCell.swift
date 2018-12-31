//
//  TutorCollectionViewCell.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/27/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

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
            self.subject.text = post.subject
            if let pay = post.hourlyPay{
                if pay != "Free"{
                    self.hourlyPay.text = "$\(pay)/hour"
                } else {
                    self.hourlyPay.text = "Free"
                }
            }
            if let fn = post.userFirstName, let ln = post.userLastName{
                self.tutorName.text = "\(fn) \(ln)"
            }
        }
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
        backgroundColor = .red
        
        //profilepic setup
//        if let profilePic = profilePic{
//            profilePic.layer.cornerRadius = 15
//            profilePic.clipsToBounds = true
//        }
        profilePic.contentMode = .scaleToFill
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2.0
        
        //subjectTitle setup
        subject.textAlignment = .center
        
        //tutorName setup
        tutorName.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func setupConstraints(){
        //subjectTitle Constraints
        subject.translatesAutoresizingMaskIntoConstraints = false
        subject.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subject.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subject.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        //ProfilePic Constraints
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        profilePic.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        profilePic.topAnchor.constraint(equalTo: subject.bottomAnchor, constant : 10).isActive = true
        profilePic.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        
        //tutorName Constraints
        
        tutorName.translatesAutoresizingMaskIntoConstraints = false
        tutorName.topAnchor.constraint(equalTo: subject.bottomAnchor, constant: 10).isActive = true
        tutorName.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 10).isActive = true
    }
}
