//
//  FoodHistory.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 21/04/25.
//

import Foundation
import SwiftData

@Model
class FoodHistory {
    var id: UUID = UUID()
    var date: Date = Date()
    var food_name: String
    var calory: Double?
    var protein: Double?
    var fat: Double?
    var carbohydrate: Double?
    var image: String?

    init(food_name: String, calory: Double? = nil, protein: Double? = nil, fat: Double? = nil, carbohydrate: Double? = nil, image: String? = nil) {
        self.food_name = food_name
        self.calory = calory
        self.protein = protein
        self.fat = fat
        self.carbohydrate = carbohydrate
        self.image = image
        self.date = Date()
    }
}

