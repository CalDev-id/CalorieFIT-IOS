//
//  UserProgress.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 21/04/25.
//

import Foundation
import SwiftData
//
//@Model
//class UserProgress {
//    var xp: Int
//    var level: Int
//    var streak: Int
//
//    init(xp: Int = 0, level: Int = 1, streak: Int = 0) {
//        self.xp = xp
//        self.level = level
//        self.streak = streak
//    }
//
//}


@Model
class UserProgress {
    var xp: Int
    var level: Int
    var streak: Int
    var lastQuestReset: Date?
    
    init(xp: Int = 0, level: Int = 1, streak: Int = 0, lastQuestReset: Date? = nil) {
        self.xp = xp
        self.level = level
        self.streak = streak
        self.lastQuestReset = lastQuestReset
    }
}
