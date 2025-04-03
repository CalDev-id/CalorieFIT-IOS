//
//  BirthdayView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI

struct Birthday: View {
    @Binding var inputAge: Int?
    @State private var selectedAge: Int = 19

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.greenSecondary)
                    .frame(height: 80)

                Picker("Age", selection: $selectedAge) {
                    ForEach(1...100, id: \.self) { age in
                        Text("\(age)")
                            .font(.system(size: selectedAge == age ? 30 : 25))
                            .foregroundColor(selectedAge == age ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .fontWeight(selectedAge == age ? .semibold : .regular)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 180)
                .scaleEffect(y: 2.4)
                .scaleEffect(x: 1.2)
            }
            .frame(width: 100)
        }
        .onAppear {
            inputAge = selectedAge
        }
        .onChange(of: selectedAge) { newValue in
            inputAge = newValue
        }
    }
}

#Preview {
    Birthday(inputAge: .constant(19))
}
