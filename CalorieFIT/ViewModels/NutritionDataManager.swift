//
//  NutritionDataManager.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 26/03/25.
//

import SwiftData
import Foundation

class NutritionDataManager {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
//        print("🟢 ModelContext berhasil diinisialisasi!")
    }

    // Mendapatkan ID Hari Ini (ddMMyyyy)
    func getCurrentDateID() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter.string(from: Date())
    }

    // Cek dan Update atau Simpan Data Baru
    func updateOrInsertNutrition(calory: Double, protein: Double, fat: Double, carbohydrate: Double) {
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
                print("🆕 Data baru dibuat dan dimasukkan!")
            }
            
            try context.save()
            print("✅ Data berhasil disimpan ke database!")
        } catch {
            print("❌ Gagal menyimpan data: \(error)")
        }
    }


}
