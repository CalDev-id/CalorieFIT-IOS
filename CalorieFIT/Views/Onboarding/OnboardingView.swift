//
//  Gender.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

import SwiftUI

enum OnboardingStep {
    case name
    case age
    case gender
    case height
}

struct OnboardingView: View {
    @State private var step: OnboardingStep = .name
    @State private var inputName: String = ""
    @State private var inputAge: Int?
    @State private var selectedGender: String = "Male"
    @State private var progress: Double = 1 / 5
    
    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 10)
                        .foregroundColor(Color.gray.opacity(0.3))

                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 300 * progress, height: 10)
                        .foregroundColor(.colorGreenPrimary)
                }
                .frame(width: 280)
                
                Text("\(Int(progress * 5))/5")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.leading)
            }
            .padding()
            Text(step == .name ? "What's your name?" : step == .age ? "When's your birthday?" : "What's your gender?")
                .fontWeight(.semibold)
                .font(.system(size: 25))
            HStack{
                Text(inputName)
                Text(String(inputAge ?? 0))
                Text(selectedGender)
            }

            Spacer()
            
            if step == .name {
                NameView(inputName: $inputName)
//                GenderView()
            } else if step == .age {
                Birthday(inputAge: $inputAge)
            } else if step == .gender {
                GenderView(selectedGender: $selectedGender)
            }

            Spacer()
            PrimaryBTN(name: "Continue") {
                nextStep()
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
            break
        }
        
        progress += 1 / 5
    }
}

struct NameView: View {
    @Binding var inputName: String
    
    var body: some View {
        VStack {
            TextField("Enter Your Name", text: $inputName)
                .frame(height: 80)
                .foregroundColor(.black)
                .font(.system(size: 30))
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.colorGrayInput)
                .cornerRadius(5)
                .shadow(radius: 1)
                .padding()
        }
    }
}
struct GenderView: View {
    @Binding var selectedGender: String
    @State private var isSelected: Int = 1
    var body: some View {
        VStack {
            HStack{
                VStack {
                    ZStack{
                        Image("male")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(40)
                            .background(isSelected == 1 ? Color.colorGreenPrimary : Color.white)
                            .cornerRadius(100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 200)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    .shadow(radius: 5)
                            )
                    }
                    Text("Male")
                        .foregroundColor(isSelected == 1 ? Color.colorGreenPrimary : Color.black)
                }
                .onTapGesture {
                    self.isSelected = 1
                    selectedGender = "Male"
                }
                .padding(.trailing, 30)
                VStack {
                    Image("female")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(40)
                        .background(isSelected == 2 ? Color.colorGreenPrimary : Color.white)
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 200)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .shadow(radius: 5)
                        )
                    Text("Female")
                        .foregroundColor(isSelected == 2 ? Color.colorGreenPrimary : Color.black)
                }
                .onTapGesture {
                    self.isSelected = 2
                    selectedGender = "Female"
                }
            }
            .padding(.bottom, 20)
            Text("Prefer not to say")
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white)
                .foregroundColor(isSelected == 3 ? Color.colorGreenPrimary : Color.black)
                .font(.system(size: 16, weight: .medium))
                .cornerRadius(200)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 200)
//                        .stroke(Color.gray, lineWidth: 1) // Outline tombol
//                )
                .shadow(color: isSelected == 3 ? Color.colorGreenPrimary : Color.black.opacity(0.2), radius: 2)
                .onTapGesture {
                    self.isSelected = 3
                    selectedGender = "0"
                }

        }
    }
}

struct Birthday: View {
    @Binding var inputAge: Int?
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack{
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
        }
        .onChange(of: selectedDate) { newDate in
            inputAge = calculateAge(from: newDate)
        }
    }

    // Function to calculate age
    func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
    }
}

struct HeightView: View {
    @Binding var inputHeight: Double?
    var body: some View {
        TextField("Height (cm)", text: .constant(""))
            .onChange(of: inputHeight) { newValue in
                if let newValue = newValue {
                    print("New height: \(newValue)")
                }
            }
    }
}


#Preview {
    OnboardingView()
}
