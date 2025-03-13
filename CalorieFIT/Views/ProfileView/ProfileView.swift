//
//  ProfileView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var users: [Users]
    @StateObject private var bmrViewModel = BMRViewModel()
    
    var body: some View {
        VStack {
            if let user = users.first { // Gunakan user pertama jika tersedia
                Text("Name: \(user.inputName)")
                Text("Age: \(user.inputAge)")
                Text("Gender: \(user.selectedGender)")
                Text("Height: \(user.inputHeight, specifier: "%.1f") cm")
                Text("Weight: \(user.inputWeight, specifier: "%.1f") kg")
                
                // **Gunakan ViewModel dengan mengirim data user**
                let bmr = bmrViewModel.calculateBMR(user: user)
                let dailyCalories = bmrViewModel.calculateDailyCalories(user: user)
                let weightCategory = bmrViewModel.determineWeightCategory(user: user)
                
                Text("BMR: \(bmr, specifier: "%.1f") kcal")
                Text("Daily Calories: \(dailyCalories, specifier: "%.1f") kcal")
                
                Text("Weight Category: \(weightCategory)")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            } else {
                Text("No user data available")
            }
            
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
