//
//  OfferClassTableViewCell.swift
//  ProjectX
//
//  Created by Anthony Lee on 10/28/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class OfferClassTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUIConstraints()
    }

    func setupUIConstraints(){
        //titleLabel Constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        
        //selectedLabel Constraints
        selectedLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        selectedLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        selectedLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
