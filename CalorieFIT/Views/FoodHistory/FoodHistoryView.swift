//
//  FoodHistoryView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 21/04/25.
//

import SwiftUI
import SwiftData

struct FoodHistoryView: View {
    @Query(sort: \FoodHistory.date, order: .reverse) var allFoodHistory: [FoodHistory]

    private var groupedByDate: [String: [FoodHistory]] {
        Dictionary(grouping: allFoodHistory) { history in
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .none
            return formatter.string(from: history.date)
        }
    }
    // Tambahkan di luar struct
    let borderColors: [Color] = [.yellow, .green, .orange]


    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Food History")
                    .font(.title)
                    .padding(.bottom, 8)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if allFoodHistory.isEmpty {
                    VStack(alignment: .center, spacing: 12) {
                        Spacer().frame(height: 100)
                        Text("🥲 You haven’t eaten yet")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                } else {
//                    ForEach(groupedByDate.sorted(by: { $0.key > $1.key }), id: \.key) { dateString, items in
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("\(dateString)")
//                                .font(.headline)
//                                .padding(.bottom, 4)
//                                .foregroundColor(.gray)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//
//                            ForEach(items, id: \.id) { item in
//                                FoodHistoryItemView(item: item)
//                            }
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
                    ForEach(groupedByDate.sorted(by: { $0.key > $1.key }), id: \.key) { dateString, items in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(dateString)")
                                .font(.headline)
                                .padding(.bottom, 4)

                            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                                let borderColor = borderColors[index % borderColors.count]
                                FoodHistoryItemView(item: item, borderColor: borderColor)
                            }
                        }
                        .padding(.bottom)
                    }

                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }

    }
}

struct FoodHistoryItemView: View {
    let item: FoodHistory
    let borderColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                if let base64 = item.image,
                   let image = base64.imageFromBase64 {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 45, height: 45)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                VStack(alignment: .leading) {
                    Text(item.food_name)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    Text("🔥\(Int(item.calory ?? 0)) kcal / 1pcs")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                MacronutrientViewHistory(name: "Protein", consumed: item.protein ?? 0, goal: (item.protein ?? 0) * 1.3, color: .green)
                Spacer()
                MacronutrientViewHistory(name: "Fats", consumed: item.fat ?? 0, goal: (item.protein ?? 0) * 1.3, color: .orange)
                Spacer()
                MacronutrientViewHistory(name: "Carbs", consumed: item.carbohydrate ?? 0, goal: (item.protein ?? 0) * 1.3, color: .yellow)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                )
        )
        
    }
}



struct MacronutrientViewHistory: View {
    let name: String
    let consumed: Double
    let goal: Double
    let color: Color
    
    var progress: Double {
        min(consumed / goal, 1.0)
    }
    
    var body: some View {
        HStack {

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 8, height: 35)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .frame(width: 8, height: CGFloat(progress) * 35)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
            VStack(alignment:.leading){
                Text("\(Int(consumed))g")
                    .bold()
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    
                Text(name)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
            }

        }
    }
}
