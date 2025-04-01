//
//  NutritionModel.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 21/03/25.
//

import Foundation

struct NutritionModel: Identifiable, Codable {
    let id: Int
    let food_name: String
    let calory: Double?
    let protein: Double?
    let fat: Double?
    let carbohydrate: Double?
}
