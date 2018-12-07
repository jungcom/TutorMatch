//
//  Constants.swift
//  ProjectX
//
//  Created by Anthony Lee on 11/20/18.
//  Copyright © 2018 projectX. All rights reserved.
//

import Foundation
import UIKit

struct Constants{
    static let green = UIColor.init(red: 86/255, green: 212/255, blue: 55/255, alpha: 1)
    static let yellow = UIColor.init(red: 232/255, green: 181/255, blue: 32/255, alpha: 1)
    static let purple = UIColor.init(red: 83/255, green: 27/255, blue: 147/255, alpha: 1)
    static let lightGray = UIColor.init(red: 240/255, green: 240/250, blue: 240/250, alpha: 1)
    static let databaseURL = "https://projectx-ed29a.firebaseio.com/"
    static var hourlyPay : [String] {
        let a : [Int] = Array(5...50)
        var stringArray = a.map{String($0)}
        stringArray.insert("Free", at: 0)
        return stringArray
    }
    static let categories : [Category] = [.Academics, .Arts, .Experience, .FitnessAndSports, .Languages, .Tech]
}
