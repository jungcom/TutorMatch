//
//  CategoryFlowLayout.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/28/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class CategoryFlowLayout: UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        setup()
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func setup() {
        scrollDirection = .horizontal
        minimumLineSpacing = 15
        itemSize = CGSize(width: collectionView!.bounds.width/3.2, height: collectionView!.bounds.height-16)
        //Margins
        sectionInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        collectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
    }
}
