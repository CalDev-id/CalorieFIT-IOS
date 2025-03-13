//
//  ActivityView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI

struct ActivityView: View {
    @Binding var selectedActivity: Int
    
    let activities: [(image: String, title: String)] = [
        ("activity1", "Sedentary"),
        ("activity2", "Lightly Active"),
        ("activity3", "Moderately Active"),
        ("activity4", "Very Active"),
        ("activity5", "Super Active")
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<activities.count, id: \.self) { index in
                ActivityCard(
                    img: activities[index].image,
                    title: activities[index].title,
                    isSelected: selectedActivity == (index + 1) // ✅ Sesuaikan perbandingan
                )
                .onTapGesture {
                    selectedActivity = index + 1 // ✅ Simpan dengan nilai 1-5
                }
            }
        }
    }
}

struct ActivityCard: View {
    let img: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(img)
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 80)
        .background(Color.colorGrayInput)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.colorGreenPrimary : Color.clear, lineWidth: 2) // ✅ Border aktif hanya jika dipilih
        )
    }
}

#Preview {
    ActivityView(selectedActivity: .constant(1)) // ✅ Default ke 1 (bukan 0)
}
