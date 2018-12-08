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
        if let profilePic = profilePic{
            profilePic.layer.cornerRadius = 15
            profilePic.clipsToBounds = true
        }
    }
}
