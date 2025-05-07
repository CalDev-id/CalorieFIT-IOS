//
//  GoalView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 30/04/25.
//

import SwiftUI

struct GoalView: View {
    @Binding var selectedGoal: Int
    
    let goals: [(image: String, title: String)] = [
        ("goal2", "Maintain weight"),//goal1
        ("goal1", "Lose weight"),//goal2
        ("goal3", "Gain weight")//goal3
    ]
    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<goals.count, id: \.self) { index in
                GoalCard(
                    img: goals[index].image,
                    title: goals[index].title,
                    isSelected: selectedGoal == (index + 1)
                )
                .onTapGesture {
                    selectedGoal = index + 1 // ✅ Simpan dengan nilai 1-5
                }
            }
            Spacer()
        }
        .padding(.top)
    }
}

struct GoalCard: View {
    let img: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(img)
                .resizable()
                .frame(width: 55, height: 55)
                .padding()
            VStack(alignment: .leading){
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 65)
        .background(Color.colorGrayInput)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.colorGreenPrimary : Color.clear, lineWidth: 2) // ✅ Border aktif hanya jika dipilih
        )
    }
}

//#Preview {
//    GoalView()
//}
