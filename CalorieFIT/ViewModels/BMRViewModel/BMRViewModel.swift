//
//  BMRViewModel.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import Foundation

class BMRViewModel: ObservableObject {
    
    func calculateBMR(user: Users) -> Double {
        if user.selectedGender == "Male" {
            return (10 * user.inputWeight) + (6.25 * user.inputHeight) - (5 * Double(user.inputAge)) + 5
        } else {
            return (10 * user.inputWeight) + (6.25 * user.inputHeight) - (5 * Double(user.inputAge)) - 161
        }
    }
    
    func getActivityFactor(activityLevel: Int) -> Double {
        switch activityLevel {
        case 1:
            return 1.2   // Sedentary (little to no exercise)
        case 2:
            return 1.375 // Light activity (1-3 days/week)
        case 3:
            return 1.55  // Moderate activity (3-5 days/week)
        case 4:
            return 1.725 // Very active (6-7 days/week)
        case 5:
            return 1.9   // Super active (twice/day, intense exercise)
        default:
            return 1.2   // Default to sedentary
        }
    }
    
    func calculateDailyCalories(user: Users) -> Double {
        let bmr = calculateBMR(user: user)
        let activityFactor = getActivityFactor(activityLevel: user.selectedActivity)
        return bmr * activityFactor
    }
    
    func determineWeightCategory(user: Users) -> String {
        let bmi = user.inputWeight / pow(user.inputHeight / 100, 2) // BMI = kg/m²
        
        if bmi < 18.5 {
            return "Underweight"
        } else if bmi < 24.9 {
            return "Normal weight"
        } else {
            return "Overweight"
        }
    }
}

