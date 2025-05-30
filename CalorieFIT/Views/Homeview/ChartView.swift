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
    @State private var isShowBMR:Bool = false
    @State private var showCitationSheet:Bool = false
    
    var body: some View {
        VStack {
            HStack {
                if let user = users.first {
                    Image(user.selectedGender == "Male" ? "profile" : "female_icon")
                        .resizable()
                        .frame(width: 65, height: 65)
                        .padding(.trailing, 5)
                }
                VStack(alignment: .leading) {
                    Text("Welcome")
                        .foregroundColor(.gray)
                    Text(users.first?.inputName ?? "John Doe")
                        .font(.system(size: 19, weight: .regular))
                }
                Spacer()
                NavigationLink(destination: ChatView(), label: {
                    Image(systemName: "text.bubble")
                        .font(.system(size: 20))
                        .padding(13)
                        .background(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1.5))
                        .foregroundColor(.black)
                })
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Progress Chart
            ZStack {
                HStack {
                    Spacer()
                    Image("apple")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .offset(x: 130)
                        .rotationEffect(.degrees(-45))
                }
                .offset(y: 30)
                
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
                    HStack{
                        Text("of \(Int(dailyCalorieGoal)) Kcal")
                            .font(.title3)
                            .foregroundColor(.gray.opacity(0.5))
                        Image(systemName: "info.circle")
                            .foregroundColor(.gray.opacity(0.5))
                            .onTapGesture {
                                isShowBMR = true
                            }
                    }
                    
                }
                .offset(y: -30)
            }
            .sheet(isPresented: $isShowBMR) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Daily Calorie Recommendation (BMR-based)")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .padding(.top, 20)

                    Text("“The daily calorie recommendation provided in this app is based on the Basal Metabolic Rate (BMR) calculation using the Mifflin-St Jeor Equation, which estimates the amount of energy expended while at rest. This method is widely used in clinical and nutritional settings.”")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)

                    Link("Read the full article", destination: URL(string: "https://doi.org/10.1093/ajcn/51.2.241")!)
                        .font(.body)
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
                .padding()
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.visible)
            }

            HStack(spacing: 45) {
                MacronutrientView(name: "Protein", consumed: proteinConsumed, goal: proteinGoal, color: Color.colorGreenPrimary)
                MacronutrientView(name: "Fats", consumed: fatConsumed, goal: fatGoal, color: Color.orangePrimary)
                MacronutrientView(name: "Carbs", consumed: carbsConsumed, goal: carbsGoal, color: Color.yellow)
            }
            .offset(y: -70)
            HStack{
                Spacer()
                Button(action: {
                    showCitationSheet = true
                }) {
                    Text("How we measure this recommendation?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .underline()
                }
            }
            .padding(.trailing, 20)
            .offset(y: -65)
            .sheet(isPresented: $showCitationSheet) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Macronutrient Recommendations (Protein, Fat, Carbohydrates)")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .padding(.top, 20)

                    Text("“The daily intake recommendations for macronutrients such as protein, fat, and carbohydrates are based on the Dietary Guidelines for Americans, 2020–2025, developed by the U.S. Department of Health and Human Services and the U.S. Department of Agriculture.”")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)

                    Link("Read the full article", destination: URL(string: "https://www.dietaryguidelines.gov/resources/2020-2025-dietary-guidelines-online-materials")!)
                        .font(.body)
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
                .padding()
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.visible)
            }

            VStack(alignment: .leading) {
                Text("Track Your Daily\nIntake")
                    .font(.system(size: 30))
                    .fontWeight(.medium)
                Text("Today Calories: \(Int(consumedCalories)) Kcal")
                    .foregroundColor(Color.orangePrimary)
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity, alignment: .leading)  // Menambahkan ini untuk memastikan teks berada di kiri
            .offset(y: -50)
            .padding(.leading, 20)
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

