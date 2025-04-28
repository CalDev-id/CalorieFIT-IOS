//
//  ChatModel.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 26/04/25.
//

import Foundation

//struct ChatResponse: Codable {
//    let response: String
//}
//
struct UserPrompt: Codable {
    let user_id: String
    let user_prompt: String
}

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let role: String
    let content: String
}

struct ChatResponse: Codable {
    let results: FoodResult?
    let refined_food: String?
    let llm_response: String?
    let image_url: String?
}

struct FoodResult: Codable {
    let calories: Double?
    let carbohydrate: Double?
    let fat: Double?
    let id: Int?
    let image: String?
    let name: String?
    let proteins: Double?
}
