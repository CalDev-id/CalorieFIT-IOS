//
//  NutritionChartView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 25/04/25.
//

import SwiftUI
import SwiftData

struct NutritionChartView: View {
    @Query private var dailyNutritions: [DailyNutrition]
    @State private var selectedDayIndex: Int?

//    private let yAxisValues = [0.0, 1000.0, 1500.0, 2000.0, 2500.0]
    private let daySymbols = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        VStack(alignment: .leading) {
            // Chart View
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let points = getWeeklyCalories()
                let maxCal = yAxisValues.max() ?? 2000.0

                ZStack {
                    // Y-Axis grid lines and labels
                    // Y-Axis grid lines and labels
                    ForEach(yAxisValues, id: \.self) { value in
                        let y = height - CGFloat(value / maxCal) * height
                        HStack {
                            Text("\(Int(value))")
                                .font(.caption)
                                .frame(width: 40, alignment: .trailing)
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                        }
                        .position(x: width / 2, y: y)
                    }


                    // Chart Path
                    Path { path in
                        for (index, value) in points.enumerated() {
                            let x = CGFloat(index) / CGFloat(points.count - 1) * (width - 40) + 40
                            let y = height - CGFloat(value / maxCal) * height
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(LinearGradient(colors: [.pink, .red], startPoint: .leading, endPoint: .trailing), lineWidth: 3)

                    // Gradient Fill
                    Path { path in
                        for (index, value) in points.enumerated() {
                            let x = CGFloat(index) / CGFloat(points.count - 1) * (width - 40) + 40
                            let y = height - CGFloat(value / maxCal) * height
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                        path.addLine(to: CGPoint(x: CGFloat(points.count - 1) / CGFloat(points.count - 1) * (width - 40) + 40, y: height))
                        path.addLine(to: CGPoint(x: 40, y: height))
                        path.closeSubpath()
                    }
                    .fill(LinearGradient(colors: [.pink.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))

                    // Highlight current day
                    let currentIndex = selectedDayIndex ?? getTodayIndex() ?? 0
                    let x = CGFloat(currentIndex) / CGFloat(points.count - 1) * (width - 40) + 40
                    let y = height - CGFloat(points[currentIndex] / maxCal) * height


                        Circle()
                            .strokeBorder(.white, lineWidth: 2)
                            .background(Circle().fill(.orange))
                            .frame(width: 12, height: 12)
                            .position(x: x, y: y)

                    if let selectedIndex = selectedDayIndex ?? getTodayIndex(),
                       let today = getDateForDayIndex(selectedIndex),
                       let nutrition = dailyNutritions.first(where: { dateFromID($0.id)?.startOfDay == today.startOfDay }) {

                        NutritionTooltipView(
                            nutrition: nutrition,
                            x: x,
                            y: y
                        )
                    }


                }
            }
            .frame(height: 200)
            .padding(.top)

            // Day Labels
            HStack {
                ForEach(0..<7, id: \.self) { index in
                    let symbol = daySymbols[index]
                    let isToday = getTodayIndex() == index
                    Text(symbol)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .padding(4)
                        .background(isToday ? Color.orange : Color.clear)
                        .clipShape(Circle())
                        .foregroundColor(isToday ? .white : .primary)
                        .onTapGesture {
                            selectedDayIndex = index
                        }
                        .offset(x: 20)
                }
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
    }

    private func getWeeklyCalories() -> [Double] {
        let calendar = Calendar.current
        let today = Date()
        
        // Tentukan start of week dari hari Minggu
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        let startOfWeek = calendar.date(from: components)!
        
        var result = [Double](repeating: 0.0, count: 7)
        for nutrition in dailyNutritions {
            if let date = dateFromID(nutrition.id) {
                if calendar.isDate(date, greaterThanOrEqualTo: startOfWeek) &&
                   calendar.isDate(date, lessThanOrEqualTo: calendar.date(byAdding: .day, value: 6, to: startOfWeek)!) {
                    let weekday = calendar.component(.weekday, from: date)
                    let index = (weekday - 1) % 7 // supaya index 0-6
                    result[index] = nutrition.caloryConsumed
                }
            }
        }
        return result
    }



    private func getTodayIndex() -> Int? {
        let index = Calendar.current.component(.weekday, from: Date()) - 1
        return (0..<7).contains(index) ? index : nil
    }

    private func dateFromID(_ id: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter.date(from: id)
    }
    private var yAxisValues: [Double] {
        stride(from: 0, through: 2000, by: 500).map { $0 }
    }

}

extension Calendar {
    func isDate(_ date1: Date, greaterThanOrEqualTo date2: Date) -> Bool {
        return date1 >= date2.startOfDay
    }
    
    func isDate(_ date1: Date, lessThanOrEqualTo date2: Date) -> Bool {
        return date1 <= date2.endOfDay
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
    }
}
private func getDateForDayIndex(_ index: Int) -> Date? {
    let calendar = Calendar.current
    let today = Date()
    guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
        return nil
    }
    return calendar.date(byAdding: .day, value: index, to: startOfWeek)
}

struct NutritionTooltipView: View {
    let nutrition: DailyNutrition
    let x: CGFloat
    let y: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Protein: \(Int(nutrition.proteinConsumed))g")
            Text("Fat: \(Int(nutrition.fatConsumed))g")
            Text("Carbs: \(Int(nutrition.carbohydrateConsumed))g")
            
        }
        .font(.caption2)
        .padding(6)
        .background(Color.orange)
        .cornerRadius(8)
        .foregroundColor(.white)
        .position(x: x, y: y - 50)
    }
}
