//
//  HomeScreen.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Query private var users: [Users]
    @StateObject private var bmrViewModel = BMRViewModel()
    @StateObject var productViewModel = FoodProductViewModel()

    var body: some View {
        ScrollView {
            VStack {
                if let user = users.first {
                    let dailyCalories = bmrViewModel.calculateDailyCalories(user: user)
                    
                    CalorieChartView(dailyCalorieGoal: dailyCalories)
                    
                    NutritionChartView()
                        .offset(y: -70)
                }
            }
            .onAppear {
                productViewModel.loadJSON()
            }
        }
        .scrollIndicators(.hidden)
    }
}
