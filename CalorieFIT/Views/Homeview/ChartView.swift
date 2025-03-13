//
//  ChartView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 13/03/25.
//

import SwiftUI

struct CalorieChartView: View {
    @State private var consumedCalories: Double = 1200
    let dailyCalorieGoal: Double
    
    var todo: () -> Void
    
    var progress: Double {
        min(consumedCalories / dailyCalorieGoal, 1.0)
    }
    
    var body: some View {
        VStack {
            HStack{
                HStack {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .padding()
                .background(.green.opacity(0.5))
                .cornerRadius(40)
                Spacer()
                HStack {
                    Image(systemName: "flame")
                    Text("Points")
                }
                .padding()
                .background(Color.colorGreenPrimary)
                .cornerRadius(40)
            }
            .padding(10)
            
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    .frame(width: 300, height: 300)
                    .rotationEffect(.degrees(180))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(progress) * 0.5)
                    .stroke(Color.colorGreenPrimary, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 300, height: 300)
                    .rotationEffect(.degrees(180))
                    .animation(.easeOut(duration: 1), value: progress)
                
                VStack {
                    Text("\(Int(consumedCalories))")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                    Text("of \(Int(dailyCalorieGoal)) calories")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    //                    Text("\(Int(progress * 100))%")
                    //                        .font(.headline)
                    //                        .foregroundColor(.green)
                }
                .offset(y: -30)
            }
            .padding(.top, 20)
            
            Button(action: {
                todo()
            }) {
                Text("+ Track eat")
                    .fontWeight(.bold)
                    .frame(width: 200, height: 45)
                    .background(Color.colorGreenPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
    
// **Preview**
#Preview {
    CalorieChartView(dailyCalorieGoal: 1600, todo: {})
}
