//
//  ChatMessageCell.swift
//  ProjectX
//
//  Created by Anthony Lee on 12/5/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit

class ChatMessageCell:UICollectionViewCell{
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.purple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        
        //x,y,w,h
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //ios 9 constraints
        //x,y,w,h
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
