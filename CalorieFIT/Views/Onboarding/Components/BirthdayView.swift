//
//  BirthdayView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI

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
