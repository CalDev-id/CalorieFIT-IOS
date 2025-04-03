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
    
    @State private var showSplash: Bool = false
    
    @State private var isLoading: Bool = false
//    @State private var isSaving: Bool = false
    
    @State private var progressLoading: CGFloat = 0.0

    let progressBarWidth: CGFloat = 250

    @Environment(\.modelContext) private var modelContext
    @Query private var users: [Users]

    var body: some View {
        if !showSplash {
            SplashView(showSplash: $showSplash)
        } else if isLoading {
//            LoadingView(isSaving: $isSaving)
            VStack {
                Text("Personalizing Your Calorify \n Experience...")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                Spacer()
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                        .frame(width: 250, height: 250)
                    
                    Circle()
                        .trim(from: 0, to: progressLoading)
                        .stroke(Color.colorGreenPrimary, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .frame(width: 250, height: 250)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(progressLoading * 100))%")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                }
                Spacer()
                Text("Hang tight! We're crafting a persolalized plan just for you")
                    .multilineTextAlignment(.center)
                    .fontWeight(.light)
                    .foregroundColor(Color.gray)
            }
            .padding()
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
                    if progressLoading < 1.0 {
                        progressLoading += 0.01
                    } else {
                        timer.invalidate()
                        let newUser = Users( // ✅ Buat objek Users
                            inputName: inputName,
                            inputAge: inputAge ?? 0,
                            selectedGender: selectedGender,
                            inputHeight: inputHeight,
                            inputWeight: inputWeight,
                            selectedActivity: selectedActivity
                        )
                        
                        userViewModel.addUserFirstTime(modelContext: modelContext, user: newUser)
                    }
                }
            }
        }
        else {
            VStack {
                HStack {
                    Button(action: { if step != .name { prevStep() } }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 25))
                            .foregroundColor((step == .height || step == .weight) ? Color.white : Color.black)
                    }
                    .foregroundColor(.black)
                    .padding(.trailing)

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: progressBarWidth, height: 10)
                            .foregroundColor(Color.gray.opacity(0.3))

                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: progressBarWidth * min(progress, 1), height: 10)
                            .foregroundColor((step == .height || step == .weight) ? Color.white : Color.colorGreenPrimary)
                    }
                    .frame(width: progressBarWidth)
                    
                    Text("\(Int(progress * 6))/6")
                        .font(.headline)
                        .padding(.leading)
                        .foregroundColor((step == .height || step == .weight) ? Color.white : Color.black)
                }
                .padding(.vertical)
                
                Text(getStepText())
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .font(.system(size: 30))
                    .foregroundColor(step == .height ? Color.white : (step == .weight ? Color.white : Color.black))
                    .multilineTextAlignment(.center)

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
                    Group{
                        HStack {
                            Text("Submit")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            Image("btn1")
                            Spacer()
                            Image("btn2")
                        }
                        .padding()
                    }
                    .frame(width: 180, height: 50)
                    .background(Color.greenSecondary)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .onTapGesture {
                        isLoading = true
                    }
                } else {
                    SecondaryBTN(name: "Continue", color: step == .height ? .colorGreenRedup : (step == .weight ? .colorOrangeSecondary : .greenSecondary)) {
                        nextStep()
                    }
                }
            }
            .padding()
            .background(step == .height ? Color.greenSecondary : (step == .weight ? Color.colorOrangePrimary: Color.white))
            .navigationBarBackButtonHidden()
        }
    }

    func nextStep() {
        switch step {
        case .name:
            step = .age
        case .age:
            step = .height
        case .height:
            step = .weight
        case .weight:
            step = .gender
        case .gender:
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
            step = .gender
        case .gender:
            step = .weight
        case .weight:
            step = .height
        case .height:
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
            return "What’s your Age?"
        case .gender:
            return "What's your gender?"
        case .height:
            return "What's your current Height?"
        case .weight:
            return "What’s your current weight right now?"
        case .activity:
            return "What's your activity level?"
        }
    }
}

#Preview {
    OnboardingView()
}
