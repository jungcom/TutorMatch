//
//  Message.swift
//  ProjectX
//
//  Created by Anthony Lee on 12/3/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import UIKit
import Firebase

@objcMembers
class Message : NSObject{
    var fromId: String?
    var toId: String?
    var timestamp: NSNumber?
    var text : String?
    
//    init(dictionary: [String: Any]) {
//        self.fromId = dictionary["fromId"] as? String
//        self.text = dictionary["text"] as? String
//        self.toId = dictionary["toId"] as? String
//        self.timestamp = dictionary["timestamp"] as? NSNumber
//    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
