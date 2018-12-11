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
        
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
