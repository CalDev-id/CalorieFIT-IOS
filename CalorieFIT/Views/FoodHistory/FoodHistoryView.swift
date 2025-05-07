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

    @State private var selectedDate: Date = Date()
    
    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        let current = Date()
        let range = calendar.range(of: .day, in: .month, for: current)!
        let components = calendar.dateComponents([.year, .month], from: current)
        return range.compactMap { day -> Date? in
            var comps = components
            comps.day = day
            return calendar.date(from: comps)
        }
    }

    private var filteredHistory: [FoodHistory] {
        allFoodHistory.filter {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }

    let borderColors: [Color] = [.yellow, .green, .orange]

    // Custom formatter to display "Month" and "Day" separately
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Food History")
                .font(.title)
                .padding(.horizontal)
                .padding(.vertical)
                .fontWeight(.semibold)
            

            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack {
                        ForEach(daysInMonth, id: \.self) { date in
                            let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                            
                            VStack {
                                Text(monthFormatter.string(from: date)) // Month
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 4)
                                Text(dayFormatter.string(from: date)) // Day
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(isSelected ? Color.white : Color.gray)
                            }
                            .frame(width: 65, height: 78)
                            .padding(5)
                            .background(isSelected ? Color.orangePrimary : Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(isSelected ? .white : .black)
                            .id(date) // Assign ID to each date
                            .onTapGesture {
                                selectedDate = date
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        // Scroll to today's date
                        if let todayIndex = daysInMonth.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: Date()) }) {
                            let todayDate = daysInMonth[todayIndex]
                            withAnimation {
                                proxy.scrollTo(todayDate, anchor: .center) // Scroll to today
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if filteredHistory.isEmpty {
                        Text("🥲 No food recorded on this date")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 80)
                    } else {
                        ForEach(Array(filteredHistory.enumerated()), id: \.element.id) { index, item in
                            let borderColor = borderColors[index % borderColors.count]
                            FoodHistoryItemView(item: item, borderColor: borderColor)
                        }
                    }
                }
                .padding(.horizontal)
            }
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
                } else {
                    AsyncImage(url: URL(string: item.imageURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } placeholder: {
                        Color.gray
                            .frame(width: 45, height: 45)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
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
                
                Image(systemName: "ellipsis")
                    .font(.system(size: 20))
                    .padding(13)
                    .background(Circle().stroke(borderColor.opacity(0.5), lineWidth: 1.5))
                    .foregroundColor(.black)
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
