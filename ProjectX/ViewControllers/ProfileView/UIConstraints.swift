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
        profileView.contentMode = .scaleAspectFill
        
        //logoutButton
        logoutButton.layer.cornerRadius = 5
        logoutButton.clipsToBounds = true
        
        //Profile Picture
        profilePic.layer.cornerRadius = 20
        profilePic.layer.masksToBounds = true
        
        //UserName Label
        userName.textAlignment = .center
    }
    
    func setupConstraints(){
       //ProfileView Constraints
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true

        //Profile Pic
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
        profilePic.centerYAnchor.constraint(equalTo: profileView.centerYAnchor).isActive = true
        profilePic.widthAnchor.constraint(equalTo: profileView.heightAnchor, multiplier: 0.4).isActive = true
        profilePic.heightAnchor.constraint(equalTo: profileView.heightAnchor, multiplier: 0.4).isActive = true
        
        //User Name
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 20).isActive = true
        userName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //CollectionView Title
        collectionviewTitle.translatesAutoresizingMaskIntoConstraints = false
        collectionviewTitle.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant:5).isActive = true
        collectionviewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionviewTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //collectionview
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: collectionviewTitle.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -10).isActive = true
        
        //logout Button
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
    logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
    }
}
