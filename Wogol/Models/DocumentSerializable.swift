//
//  DocumentSerializable.swift
//  Wogol
//
//  Created by Peter Smiley on 9/4/20.
//  Copyright © 2020 HernanPeter. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(documentData: [String: Any])
}
