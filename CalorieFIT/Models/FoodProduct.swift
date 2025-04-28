//
//  FoodProduct.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 26/04/25.
//

import Foundation

struct FoodProduct: Identifiable, Codable {
    let id: Int
    let calories: Double
    let proteins: Double
    let fat: Double
    let carbohydrate: Double
    let name: String
    let image: String
}
