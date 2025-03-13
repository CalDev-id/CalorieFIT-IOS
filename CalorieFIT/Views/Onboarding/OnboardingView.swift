//
//  Gender.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

import SwiftUI
import SwiftData

enum OnboardingStep {
    case name
    case age
    case gender
    case height
    case weight
    case activity
}

struct OnboardingView: View {
    @StateObject private var userViewModel = UserViewModel()
    
    @State private var step: OnboardingStep = .name
    @State private var inputName: String = ""
    @State private var inputAge: Int?
    @State private var selectedGender: String = "Male"
    @State private var progress: Double = 1 / 6.0
    @State private var inputHeight: Double = 120
    @State private var inputWeight: Double = 40
    @State private var selectedActivity: Int = 1

    let progressBarWidth: CGFloat = 250

    @Environment(\.modelContext) private var modelContext
    @Query private var users: [Users]

    var body: some View {
        VStack {
            HStack {
                Button(action: { if step != .name { prevStep() } }) {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 25))
                }
                .foregroundColor(.black)
                .padding(.trailing)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: progressBarWidth, height: 10)
                        .foregroundColor(Color.gray.opacity(0.3))

                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: progressBarWidth * min(progress, 1), height: 10)
                        .foregroundColor(Color.colorGreenPrimary)
                }
                .frame(width: progressBarWidth)
                
                Text("\(Int(progress * 6))/6")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.leading)
            }
            .padding(.vertical)
            
            Text(getStepText())
                .fontWeight(.semibold)
                .font(.system(size: 25))

            Spacer()
            
            switch step {
            case .name:
                NameView(inputName: $inputName)
            case .age:
                Birthday(inputAge: $inputAge)
            case .gender:
                GenderView(selectedGender: $selectedGender)
            case .height:
                HeightView(inputHeight: $inputHeight)
            case .weight:
                WeightView(inputWeight: $inputWeight)
            case .activity:
                ActivityView(selectedActivity: $selectedActivity)
            }
            
            Spacer()
            
            if step == .activity {
                Text("Submit")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 45)
                    .background(Color.colorGreenPrimary)
                    .cornerRadius(10)
                    .onTapGesture {
                        let newUser = Users( // ✅ Buat objek Users
                            inputName: inputName,
                            inputAge: inputAge ?? 0,
                            selectedGender: selectedGender,
                            inputHeight: inputHeight,
                            inputWeight: inputWeight,
                            selectedActivity: selectedActivity
                        )
                        
                        userViewModel.addUserFirstTime(modelContext: modelContext, user: newUser) // ✅ Panggil fungsi dengan benar
                    }
            } else {
                PrimaryBTN(name: "Continue") {
                    nextStep()
                }
            }
        }
        .padding()
    }

    func nextStep() {
        switch step {
        case .name:
            step = .age
        case .age:
            step = .gender
        case .gender:
            step = .height
        case .height:
            step = .weight
        case .weight:
            step = .activity
            progress = 1.0
        case .activity:
            break
        }
        progress = min(progress + (1 / 6.0), 1)
    }

    func prevStep() {
        switch step {
        case .activity:
            step = .weight
        case .weight:
            step = .height
        case .height:
            step = .gender
        case .gender:
            step = .age
        case .age:
            step = .name
        case .name:
            break
        }
        progress = max(progress - (1 / 6.0), 1 / 6.0)
    }

    func getStepText() -> String {
        switch step {
        case .name:
            return "What's your name?"
        case .age:
            return "When's your birthday?"
        case .gender:
            return "What's your gender?"
        case .height:
            return "How tall are you?"
        case .weight:
            return "What's your current weight?"
        case .activity:
            return "What's your activity level?"
        }
    }
}

#Preview {
    OnboardingView()
}
