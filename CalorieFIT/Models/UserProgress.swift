//
//  UserProgress.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 21/04/25.
//

//import Foundation
//import SwiftData
//
//@Model
//class UserProgress {
//    var xp: Int
//    var level: Int
//    var streak: Int
//    var lastScanDate: Date?
//    
//    var dailyChallengeDate: Date? = nil
//    var dailyChallenges: [String] = []
//
//    init(xp: Int = 0, level: Int = 1, streak: Int = 0) {
//        self.xp = xp
//        self.level = level
//        self.streak = streak
//        self.lastScanDate = nil
//    }
//
//    func gainXP(amount: Int) {
//        xp += amount
//        let xpNeeded = level * 100
//        if xp >= xpNeeded {
//            xp -= xpNeeded
//            level += 1
//        }
//    }
//}
