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
    @Query private var userProgress: [UserProgress]
    @StateObject private var bmrViewModel = BMRViewModel()
    
    var body: some View {
        if let user = users.first {
            ScrollView {
                VStack() {
                    HeaderView()
                    ProfileInfoView(user: user)
                    if let progress = userProgress.first {
                        StatView(userProgress: progress)
                    }
                    BMIBarView(bmi: bmrViewModel.userBMI(user: user))
                    DetailProfileView(user: user)
                }
                .padding(.horizontal)
                .background(.white)
            }
        } else {
            Text("No user data available")
        }
    }
    
    @ViewBuilder
    private func StatView(userProgress: UserProgress) -> some View {
        HStack {
            HStack {
                Text("🆙 Level: \(userProgress.level)")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .cornerRadius(16)
                    .shadow(radius: 1)
                
                Text("🔥 Streak: \(userProgress.streak) hari")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .cornerRadius(16)
                    .shadow(radius: 1)
            }
        }
    }

    
    // MARK: - Header View
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Spacer()
            Text("Profile")
                .font(.title2)
                .fontWeight(.medium)
            Spacer()
        }
        .frame(height: 50)
        .padding(.horizontal, 5)
    }

    // MARK: - Profile Info
    @ViewBuilder
    private func ProfileInfoView(user: Users) -> some View {
        VStack() {
            Image(user.selectedGender == "Male" ? "profile" : "female_icon")
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(100)
            Text("\(user.inputName)")
                .font(.headline)
        }
        .padding()
        .foregroundColor(.black)
    }

    // MARK: - BMI Bar
    @ViewBuilder
    private func BMIBarView(bmi: Double) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current BMI")
                .font(.headline)
            
            HStack {
                Text("\(bmi, specifier: "%.1f")")
                    .font(.largeTitle)
                    .bold()
                Text(bmiCategory(bmi))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(categoryColor(bmi))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            
            ZStack(alignment: .leading) {
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .green, .yellow, .red]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 10)
                .cornerRadius(5)
                
                GeometryReader { geo in
                    Circle()
                        .fill(Color.white)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        .frame(width: 20, height: 20)
                        .position(x: position(for: bmi, width: geo.size.width), y: 10)
                }
                .frame(height: 20)
            }
            
            HStack {
                HStack{
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                    Text("Underweight").font(.caption2).foregroundColor(.black)
                }
                Spacer()
                HStack{
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text("Healthy").font(.caption2).foregroundColor(.black)
                }
                
                Spacer()
                HStack{
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 10, height: 10)
                    Text("Overweight").font(.caption2).foregroundColor(.black)
                }
                
                Spacer()
                HStack{
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                    Text("Obese").font(.caption2).foregroundColor(.black)
                }
            }
            .padding(.horizontal, 4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 1)
    }

    // MARK: - Detailed Info
    @ViewBuilder
    private func DetailProfileView(user: Users) -> some View {
        HStack(alignment: .top) {
            Image(user.selectedGender == "Male" ? "body_male" : "body_female")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 190)
                .padding(.trailing, 30)
//            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                profileItem(icon: "person.fill", title: "Age", value: "\(user.inputAge)")
                profileItem(icon: "scalemass", title: "Weight", value: "\(String(format: "%.1f", user.inputWeight)) Kg")
                profileItem(icon: "target", title: "Height", value: "\(String(format: "%.1f", user.inputHeight)) Cm")
                profileItem(icon: "figure.walk", title: "Activity Level", value: getActivityFactor(activityLevel: user.selectedActivity))
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 1)
    }

    // MARK: - Helper View
    @ViewBuilder
    private func profileItem(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.gray)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.body.bold())
            }
        }
    }

    // MARK: - Logic Helpers
    private func getActivityFactor(activityLevel: Int) -> String {
        switch activityLevel {
        case 1: return "Sedentary"
        case 2: return "Light activity"
        case 3: return "Moderate activity"
        case 4: return "Very active"
        case 5: return "Super active"
        default: return "Sedentary"
        }
    }

    private func bmiCategory(_ bmi: Double) -> String {
        switch bmi {
        case ..<18.5: return "Underweight"
        case 18.5..<25: return "Healthy"
        case 25..<30: return "Overweight"
        default: return "Obese"
        }
    }

    private func categoryColor(_ bmi: Double) -> Color {
        switch bmi {
        case ..<18.5: return .blue
        case 18.5..<25: return .green
        case 25..<30: return .yellow
        default: return .red
        }
    }

    private func position(for bmi: Double, width: CGFloat) -> CGFloat {
        let normalizedBMI = min(max(bmi, 10), 40)
        return (normalizedBMI - 10) / 30 * width
    }
}
