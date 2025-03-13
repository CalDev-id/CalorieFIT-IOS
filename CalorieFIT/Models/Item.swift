//
//  Item.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
