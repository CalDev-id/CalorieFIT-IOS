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
        let tdee = bmr * activityFactor  // Total Daily Energy Expenditure
        
        switch user.selectedGoal {
        case 1: // Maintenance
            return tdee
        case 2: // Diet
            return tdee * 0.8  // Potong 20%
        case 3: // Bulking
            return tdee * 1.2  // Tambah 20%
        default:
            return tdee
        }
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
    
    func userBMI(user: Users) -> Double {
        return user.inputWeight / pow(user.inputHeight / 100, 2)
    }
    
    func determineMacronutrients(user: Users) -> (protein: Double, fat: Double, carbs: Double) {
        let totalCalories = calculateDailyCalories(user: user)
        
        // **Protein**
        let proteinPerKg: Double = user.selectedActivity >= 3 ? 1.6 : 1.2  // Lebih tinggi jika aktif
        let proteinGrams = proteinPerKg * user.inputWeight
        let proteinCalories = proteinGrams * 4
        
        // **Fat (Lemak) → 20-30% dari total kalori**
        let fatCalories = totalCalories * 0.25
        let fatGrams = fatCalories / 9
        
        // **Carbs (Karbohidrat) → Sisa setelah protein & fat dihitung**
        let remainingCalories = totalCalories - (proteinCalories + fatCalories)
        let carbGrams = remainingCalories / 4
        
        return (proteinGrams, fatGrams, carbGrams)
    }
}

