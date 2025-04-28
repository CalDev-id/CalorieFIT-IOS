//
//  GamificationViewModel.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 21/04/25.
//


import Foundation
import SwiftData
import Combine

class GamificationViewModel: ObservableObject {
    var context: ModelContext? {
        didSet {
            if context != nil {
                loadQuestsFromUserDefaults()
            }
        }
    }

    init(context: ModelContext? = nil) {
        self.context = context
        if context != nil {
            loadQuestsFromUserDefaults()
        }
    }

    enum QuestType: String, CaseIterable, Identifiable, Codable {
        case proteinOver10 = "Scan makanan tinggi protein (>10g)"
        case fatUnder5 = "Scan makanan rendah lemak (<5g)"
        case calorieUnder300 = "Scan makanan dengan <300 kalori"
        case carbOver30 = "Scan makanan tinggi karbo (>10g)"
        case proteinOver15 = "Scan makanan dengan protein >15g"

        var id: String { rawValue }

        func evaluate(cal: Double, protein: Double, fat: Double, carb: Double) -> Bool {
            switch self {
            case .proteinOver10: return protein > 10
            case .fatUnder5: return fat < 5
            case .calorieUnder300: return cal < 300
            case .carbOver30: return carb > 10
            case .proteinOver15: return protein > 15
            }
        }
    }

    struct Quest: Identifiable, Equatable, Codable {
        let id: UUID
        let type: QuestType
        var isCompleted: Bool

        var name: String { type.rawValue }

        init(type: QuestType, isCompleted: Bool = false) {
            self.id = UUID()
            self.type = type
            self.isCompleted = isCompleted
        }
    }
    private let lastResetKey = "lastQuestReset"

    private func shouldResetQuests() -> Bool {
        if let lastReset = UserDefaults.standard.object(forKey: lastResetKey) as? Date {
            return !Calendar.current.isDateInToday(lastReset)
        }
        return true
    }
    
    func resetDailyQuestsIfNeeded() {
        if shouldResetQuests() {
            generateDailyQuests()
            UserDefaults.standard.set(Date(), forKey: lastResetKey)
        } else {
            loadQuestsFromUserDefaults()
        }
    }



    @Published var dailyQuests: [Quest] = [] {
        didSet {
            saveQuestsToUserDefaults()
        }
    }

    private let questsKey = "dailyQuests"

    private func saveQuestsToUserDefaults() {
        if let data = try? JSONEncoder().encode(dailyQuests) {
            UserDefaults.standard.set(data, forKey: questsKey)
        }
    }

    private func loadQuestsFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: questsKey),
           let decoded = try? JSONDecoder().decode([Quest].self, from: data) {
            dailyQuests = decoded
        } else {
            generateDailyQuests()
        }
    }

    private func generateDailyQuests() {
        dailyQuests = Array(QuestType.allCases.shuffled().prefix(3)).map {
            Quest(type: $0)
        }
    }

    func updateProgress(food_name: String, calory: Double, protein: Double, fat: Double, carbohydrate: Double) {
        do {
            guard let userProgress = try context?.fetch(FetchDescriptor<UserProgress>()).first else { return }

            var updatedQuests = dailyQuests
            var xpGained = 0

            for i in updatedQuests.indices {
                if !updatedQuests[i].isCompleted &&
                    updatedQuests[i].type.evaluate(cal: calory, protein: protein, fat: fat, carb: carbohydrate) {
                    
                    updatedQuests[i].isCompleted = true
                    xpGained += 35
                    print("✅ Quest '\(updatedQuests[i].name)' selesai! +35 XP")
                }
            }

            // Trigger UI update
            dailyQuests = updatedQuests

            userProgress.xp += xpGained
            if userProgress.xp >= 100 {
                userProgress.level += 1
                userProgress.xp -= 100
                print("🏆 Naik level ke \(userProgress.level)!")
            }

            try context?.save()
        } catch {
            print("❌ Gagal memperbarui progress: \(error)")
        }
    }
}

