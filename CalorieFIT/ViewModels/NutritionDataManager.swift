//
//  NutritionDataManager.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 26/03/25.
//

import SwiftData
import Foundation
import UIKit

class NutritionDataManager {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // Mendapatkan ID Hari Ini (ddMMyyyy)
    func getCurrentDateID() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter.string(from: Date())
    }

    func updateOrInsertNutrition(food_name: String, calory: Double, protein: Double, fat: Double, carbohydrate: Double, image: UIImage?) {
        let todayID = getCurrentDateID()
        print("🟢 Menyimpan data dengan ID: \(todayID)")

        let fetchDescriptor = FetchDescriptor<DailyNutrition>(predicate: #Predicate { $0.id == todayID })

        do {
            if let existingData = try context.fetch(fetchDescriptor).first {
                existingData.caloryConsumed += calory
                existingData.proteinConsumed += protein
                existingData.fatConsumed += fat
                existingData.carbohydrateConsumed += carbohydrate
                print("🔄 Data ditemukan, melakukan update...")
            } else {
                let newNutrition = DailyNutrition(
                    id: todayID,
                    calory: calory,
                    protein: protein,
                    fat: fat,
                    carbohydrate: carbohydrate
                )
                context.insert(newNutrition)
                // streak + 1
                let fetchProgress = FetchDescriptor<UserProgress>()
                if let updateProgress = try context.fetch(fetchProgress).first {
                    updateProgress.streak += 1
                    print("🔥 Streak +1")
                }
                
                print("🆕 Data baru dibuat dan dimasukkan!")
            }

            // 🔄 Tambahkan ke model FoodHistory
            let base64Image = image?.base64
            let foodHistory = FoodHistory(
                food_name: food_name,
                calory: calory,
                protein: protein,
                fat: fat,
                carbohydrate: carbohydrate,
                image: base64Image
            )
            context.insert(foodHistory)
            print("📜 FoodHistory berhasil disimpan.")

            try context.save()
            print("✅ Semua data berhasil disimpan ke database!")

        } catch {
            print("❌ Gagal menyimpan data: \(error)")
        }
    }
}
