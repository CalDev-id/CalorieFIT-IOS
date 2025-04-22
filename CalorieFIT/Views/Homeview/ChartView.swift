//
//  ChartView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 13/03/25.
//

import SwiftUI
import SwiftData

struct CalorieChartView: View {
    @Query private var users: [Users]
    @Environment(\.modelContext) private var modelContext
    @Query private var dailyNutritions: [DailyNutrition]
    
    let dailyCalorieGoal: Double
    
    // Mengambil data hari ini
    var todayNutrition: DailyNutrition? {
        let todayID = getCurrentDateID()
        return dailyNutritions.first { $0.id == todayID }
    }

    // Mengambil ID Hari Ini
    func getCurrentDateID() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter.string(from: Date())
    }
    
    // Data konsumsi hari ini dari SwiftData
    private var consumedCalories: Double {
        todayNutrition?.caloryConsumed ?? 0
    }
    
    private var proteinConsumed: Double {
        todayNutrition?.proteinConsumed ?? 0
    }
    
    private var fatConsumed: Double {
        todayNutrition?.fatConsumed ?? 0
    }
    
    private var carbsConsumed: Double {
        todayNutrition?.carbohydrateConsumed ?? 0
    }
    
    var progress: Double {
        min(consumedCalories / dailyCalorieGoal, 1.0)
    }
    
    // Target makronutrisi berdasarkan data pengguna
    var proteinGoal: Double {
        guard let user = users.first else { return 0 }
        return BMRViewModel().determineMacronutrients(user: user).protein
    }
    
    var fatGoal: Double {
        guard let user = users.first else { return 0 }
        return BMRViewModel().determineMacronutrients(user: user).fat
    }
    
    var carbsGoal: Double {
        guard let user = users.first else { return 0 }
        return BMRViewModel().determineMacronutrients(user: user).carbs
    }
    
    var proteinProgress: Double {
        min(proteinConsumed / proteinGoal, 1.0)
    }
    
    var fatProgress: Double {
        min(fatConsumed / fatGoal, 1.0)
    }
    
    var carbsProgress: Double {
        min(carbsConsumed / carbsGoal, 1.0)
    }
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Image("profile")
                    .resizable()
                    .frame(width: 65, height: 65)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    Text("Welcome")
                        .foregroundColor(.gray)
                    Text(users.first?.inputName ?? "John Doe")
                        .font(.system(size: 19, weight: .regular))
                }
                Spacer()
                
//                ZStack {
//                    Image(systemName: "magnifyingglass")
//                        .font(.system(size: 20))
//                        .padding(8)
//                }
//                .overlay(
//                    RoundedRectangle(cornerRadius: 100)
//                        .stroke(Color.black.opacity(0.3), lineWidth: 2)
//                )
//                
//                ZStack {
//                    Image(systemName: "bell")
//                        .font(.system(size: 20))
//                        .padding(8)
//                }
//                .overlay(
//                    RoundedRectangle(cornerRadius: 100)
//                        .stroke(Color.black.opacity(0.3), lineWidth: 2)
//                )
                Text("Level 1")
                    .font(.system(size: 17, weight: .medium))
            }
            .padding(20)
            
            // Progress Chart
            ZStack {
                HStack {
                    Spacer()
                    Image("avocado")
                }
                .offset(y: -50)
                
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(Color.orangeSecondary, lineWidth: 20)
                    .frame(width: 224, height: 224)
                    .rotationEffect(.degrees(180))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(progress) * 0.5)
                    .stroke(Color.orangePrimary, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 224, height: 224)
                    .rotationEffect(.degrees(180))
                    .animation(.easeOut(duration: 1), value: progress)
                
                VStack {
                    Text("🔥")
                        .font(.system(size: 45))
                    Text("\(Int(consumedCalories)) Kcal")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                    Text("of \(Int(dailyCalorieGoal)) Kcal")
                        .font(.title3)
                        .foregroundColor(.gray.opacity(0.5))
                }
                .offset(y: -30)
            }
            
            // Makronutrisi Progress
            HStack(spacing: 45) {
                MacronutrientView(name: "Protein", consumed: proteinConsumed, goal: proteinGoal, color: Color.colorGreenPrimary)
                MacronutrientView(name: "Fats", consumed: fatConsumed, goal: fatGoal, color: Color.orangePrimary)
                MacronutrientView(name: "Carbs", consumed: carbsConsumed, goal: carbsGoal, color: Color.yellow)
            }
            .offset(y: -60)
        }
    }
}

struct MacronutrientView: View {
    let name: String
    let consumed: Double
    let goal: Double
    let color: Color
    
    var progress: Double {
        min(consumed / goal, 1.0)
    }
    
    var body: some View {
        VStack {
            Text(name)
                .font(.headline)
                .foregroundColor(.black)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 10)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .frame(width: CGFloat(progress) * 80, height: 10)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
            
            Text("\(Int(consumed))/\(Int(goal))g")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    CalorieChartView(dailyCalorieGoal: 1600)
}

