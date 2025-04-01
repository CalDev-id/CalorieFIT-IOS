//
//  DailyNutrition.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 26/03/25.
//

import SwiftData
import Foundation

@Model
class DailyNutrition {
    @Attribute(.unique) var id: String // Format: "26032025"
    var caloryConsumed: Double
    var proteinConsumed: Double
    var fatConsumed: Double
    var carbohydrateConsumed: Double

    init(id: String, calory: Double, protein: Double, fat: Double, carbohydrate: Double) {
        self.id = id
        self.caloryConsumed = calory
        self.proteinConsumed = protein
        self.fatConsumed = fat
        self.carbohydrateConsumed = carbohydrate
    }
}
