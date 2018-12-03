//
//  CategoryCollectionViewCell.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/28/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
    }
}
