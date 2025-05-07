//
//  FoodProductModel.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 26/04/25.
//

import Foundation

class FoodProductViewModel: ObservableObject {
    @Published var products: [FoodProduct] = []
    
    func loadJSON() {
        if let url = Bundle.main.url(forResource: "data_barang", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let loadedProducts = try decoder.decode([FoodProduct].self, from: data)
                DispatchQueue.main.async {
                    self.products = loadedProducts
//                    print("Loaded products: \(self.products)") // Pastikan ini menampilkan produk
//                    print("Products Count: \(self.products.count)") // Hitung jumlah produk
                }
            } catch {
//                print("Failed to load JSON: \(error)")
            }
        } else {
//            print("JSON file not found")
        }
    }

}
