//
//  tutorFlowLayout.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/27/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class TutorFlowLayout: UICollectionViewFlowLayout{
    let leftRightInset = 10.0 as CGFloat
    
    override func prepare() {
        super.prepare()
        setup()
    }
    
    private func setup() {
        scrollDirection = .vertical
        minimumLineSpacing = 15
        itemSize = CGSize(width: collectionView!.bounds.width/2 - leftRightInset*2, height: collectionView!.bounds.height/4)
        //Margins
        sectionInset = UIEdgeInsets(top: leftRightInset, left: leftRightInset, bottom: leftRightInset, right: leftRightInset)
        collectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
    }
}
