//
//  NutritionViewModel.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 21/03/25.
//

import Foundation

class NutritionViewModel: ObservableObject {
    @Published var nutrition: [NutritionModel] = []
    
    func loadJSON() {
        if let url = Bundle.main.url(forResource: "food_calory", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonString = String(data: data, encoding: .utf8) ?? "Invalid JSON"
                print("📜 JSON Content: \(jsonString)") // Debugging JSON content sebelum parsing
                
                let decoder = JSONDecoder()
                let loadedProducts = try decoder.decode([NutritionModel].self, from: data)
                
                DispatchQueue.main.async {
                    self.nutrition = loadedProducts
//                    print("✅ Loaded Nutrition Data: \(self.nutrition)")
                }
            } catch {
//                print("❌ Failed to decode JSON: \(error)")
            }
        } else {
//            print("❌ JSON file not found")
        }
    }



}
