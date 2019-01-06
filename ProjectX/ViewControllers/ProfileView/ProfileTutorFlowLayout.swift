//
//  ProfileTutorFlowLayout.swift
//  ProjectX
//
//  Created by Anthony Lee on 11/27/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class ProfileTutorFlowLayout: UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        setup()
    }
    
    private func setup() {
        scrollDirection = .vertical
        minimumLineSpacing = 5
        itemSize = CGSize(width: collectionView!.bounds.width, height: collectionView!.bounds.height/2.2)
        //Margins
        sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
        collectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
        invalidateLayout()
    }
}
