//
//  FoodSearchView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 26/04/25.
//

import SwiftUI

struct FoodSearchView: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    let foods: [FoodProduct]
    let borderColors: [Color] = [.yellow, .green, .orange]
    //new
    @State private var selectedFood: FoodProduct? = nil
    @State private var navigateToDetail: Bool = false
    
    var filteredProducts: [FoodProduct] {
        if searchText.isEmpty {
            return foods
        } else {
            return foods.filter { product in
                product.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Find ur food")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 15)
                
                SearchBar(text: $searchText)
                
                List {
                    ForEach(filteredProducts.indices, id: \.self) { index in
                        let product = filteredProducts[index]
                        let borderColor = borderColors[index % borderColors.count]
                        
                        Button {
                            selectedFood = product
                            navigateToDetail = true
                        } label: {
                            FoodItemView(item: product, borderColor: borderColor)
                        }
                        .listRowInsets(EdgeInsets())
                        .background(Color.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    }
                }
                .listStyle(PlainListStyle())
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button("Cancel") {
//                            dismiss()
//                        }
//                    }
//                }
                
                // NavigationLink ke Detail View
                NavigationLink(
                    destination: Group {
                        if let food = selectedFood {
                            FoodDetectFromSearchView(
                                ImageURL: .constant(food.image),
                                name: .constant(food.name),
                                calories: .constant(String(format: "%.0f", food.calories)),
                                protein: .constant(food.proteins),
                                fat: .constant(food.fat),
                                carbs: .constant(food.carbohydrate),
                                showResultSheet: $isPresented // binding yang sama
                            )
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $navigateToDetail,
                    label: { EmptyView() }
                )
                .hidden()

                
            }
            .padding(.top, 20)
        }
    }
}
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Search your product", text: $text)
            .padding(15)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray, lineWidth: 1)
            )
            .overlay(
                HStack {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing, 10)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                }
            )
            .padding(.horizontal)
    }
}

struct FoodItemView: View {
    let item: FoodProduct
    let borderColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: item.image)) { image in
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
                
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    Text("🔥\(Int(item.calories ?? 0)) kcal / 1pcs")
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
                NutrientViewHistory(name: "Protein", consumed: item.proteins ?? 0, goal: (item.proteins ?? 0) * 1.3, color: .green)
                Spacer()
                NutrientViewHistory(name: "Fats", consumed: item.fat ?? 0, goal: (item.proteins ?? 0) * 1.3, color: .orange)
                Spacer()
                NutrientViewHistory(name: "Carbs", consumed: item.carbohydrate ?? 0, goal: (item.proteins ?? 0) * 1.3, color: .yellow)
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

struct NutrientViewHistory: View {
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
            VStack(alignment: .leading) {
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
