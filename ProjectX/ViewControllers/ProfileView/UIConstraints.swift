//
//  UIConstraints.swift
//  ProjectX
//
//  Created by Anthony Lee on 1/3/19.
//  Copyright © 2019 projectX. All rights reserved.
//

import UIKit

extension ProfileViewController {
    func setupUI(){
        self.profileView.backgroundColor = UIColor(patternImage: UIImage(named: "purple")!)
        
        //logoutButton
        logoutButton.layer.cornerRadius = 5
        logoutButton.clipsToBounds = true
        
        //Profile Picture
        profilePic.layer.cornerRadius = 20
        profilePic.layer.masksToBounds = true
    }
    
    func setupConstraints(){
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true

        
    }
}
