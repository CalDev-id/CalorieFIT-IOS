//
//  GenderView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI

struct GenderView: View {
    @Binding var selectedGender: String
    @State private var isSelected: Int = 1
    var body: some View {
        VStack {
            HStack{
                VStack {
                    ZStack{
                        Image("profile")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .padding(5)
//                            .background(isSelected == 1 ? Color.colorGreenPrimary : Color.white)
                            .cornerRadius(100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 200)
                                    .stroke(isSelected == 1 ? Color.colorGreenPrimary : Color.white, lineWidth: 2)
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
                    Image("female_1")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(5)
//                        .background(isSelected == 2 ? Color.colorGreenPrimary : Color.white)
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 200)
                                .stroke(isSelected == 2 ? Color.colorGreenPrimary : Color.white, lineWidth: 2)
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

//#Preview {
//    @Previewable @State var selectedWeight: String = "ayam"
//    GenderView(selectedGender: $selectedWeight)
//}
