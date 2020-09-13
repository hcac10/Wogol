//
//  Goal.swift
//  Wogol
//
//  Created by Peter Smiley on 9/4/20.
//  Copyright © 2020 HernanPeter. All rights reserved.
//

import Foundation

struct Key {
    struct User {
        static let uid = "uid"
        static let name = "name"
        static let priority = "priority"
        static let color = "color"
    }
}

struct Value {
    struct Empty {
        static let string = ""
        static let int = 1
    }
}

// Goal model
struct Goal {
//    private(set) var uid: String
    private(set) var name: String
    private(set) var priority: Int
    private(set) var color: String
    
    var dictionary: [String: Any] {
        return [
//            Key.User.uid: uid,
            Key.User.name: name,
            Key.User.priority: priority,
            Key.User.color: color,
        ]
    }
}

// Handles unpacking and default values
extension Goal: DocumentSerializable {
    init?(documentData: [String : Any]) {
//        let uid = documentData[Key.User.uid] as? String ?? Value.Empty.string
        let name = documentData[Key.User.name] as? String ?? Value.Empty.string
        let priority = documentData[Key.User.priority] as? Int ?? Value.Empty.int
        let color = documentData[Key.User.color] as? String ?? Value.Empty.string

        self.init(
//            uid: uid,
            name: name,
            priority: priority,
            color: color
        )
    }
    
    
}
