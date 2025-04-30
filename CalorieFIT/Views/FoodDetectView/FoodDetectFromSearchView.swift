//
//  FoodDetectFromSearchView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 30/04/25.
//

import SwiftUI
import Vision
import SwiftData

struct FoodDetectFromSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var ImageURL: String?
    @Binding var name: String?
    @Binding var calories: String?
    @Binding var protein: Double?
    @Binding var fat: Double?
    @Binding var carbs: Double?

    @Binding var showResultSheet: Bool
    @StateObject var viewModel = NutritionViewModel()
    @State private var navigateToContentView = false

    // Graph
    @Query private var users: [Users]
    @Query private var dailyNutritions: [DailyNutrition]
    @State private var proteinConsumed: Double = 0
    @State private var fatConsumed: Double = 0
    @State private var carbsConsumed: Double = 0

    var proteinGoal: Double {
        users.first.map { BMRViewModel().determineMacronutrients(user: $0).protein } ?? 0
    }

    var fatGoal: Double {
        users.first.map { BMRViewModel().determineMacronutrients(user: $0).fat } ?? 0
    }

    var carbsGoal: Double {
        users.first.map { BMRViewModel().determineMacronutrients(user: $0).carbs } ?? 0
    }

    @Environment(\.modelContext) private var modelContext
    private var nutritionManager: NutritionDataManager {
        NutritionDataManager(context: modelContext)
    }
    private var GMViewModel: GamificationViewModel {
        GamificationViewModel(context: modelContext)
    }

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            if let image = ImageURL {
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            withAnimation {
                                showResultSheet = false
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .padding(10)
                                .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Text("Nutrition")
                            .font(.title2)
                            .fontWeight(.medium)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20))
                                .padding(13)
                                .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                                .foregroundColor(.black)
                        }
                    }
                    .frame(height: 50)
                    .background(.white)
                    .padding(.top, 55)
                    .padding(.horizontal, 20)

                    AsyncImage(url: URL(string: image)) { image in
                        image
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                    } placeholder: {
                        Color.gray
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                    }

                    Spacer()
                }
                .background(.white)
            }

            VStack {
                Spacer()

                VStack(spacing: 16) {
                    HStack {
                        Text(name?.capitalized ?? "Unknown")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                        Spacer()
                        Text("1 Pcs")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 25)

                    HStack {
                        Text("Nutrition Value")
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(String(format: "%.0f", Double(calories ?? "0") ?? 0)) Cals")
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                    }
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 25)

                    MacronutrientDetailView(image: "protein", name: "Protein", contain: (protein ?? 0), goal: proteinGoal, color: Color.green)
                    MacronutrientDetailView(image: "carbs", name: "Carbs", contain: (carbs ?? 0), goal: carbsGoal, color: Color.yellow)
                    MacronutrientDetailView(image: "fat", name: "Fat", contain: (fat ?? 0), goal: fatGoal, color: Color.orange)

                    SecondaryBTN(name: "Confirm", color: Color.colorGreenPrimary) {
                        // Insert data directly
                        nutritionManager.updateOrInsertNutrition(
                            food_name: name ?? "Unknown",
                            calory: Double(calories ?? "0") ?? 0,
                            protein: protein ?? 0,
                            fat: fat ?? 0,
                            carbohydrate: carbs ?? 0,
                            image: nil,
                            imageURL: ImageURL
                        )

                        GMViewModel.updateProgress(
                            food_name: name ?? "Unknown",
                            calory: Double(calories ?? "0") ?? 0,
                            protein: protein ?? 0,
                            fat: fat ?? 0,
                            carbohydrate: carbs ?? 0
                        )

                        dismiss()
                        withAnimation {
                            showResultSheet = false 
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .background(.white)
                .clipShape(RoundedCorners(radius: 30, corners: [.topLeft, .topRight]))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
        .onDisappear {
            showResultSheet = false // Ini kunci untuk menutup FoodSearchView bersamaan
        }
    }
}
