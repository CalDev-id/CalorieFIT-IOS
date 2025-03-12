//
//  ResultView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI
import SwiftData

struct resultView: View {
    @Query private var users: [Users] 
    
    var body: some View {
        VStack {
            if users.isEmpty {
                Text("No data available")
            } else {
                ForEach(users) { user in
                    Text("Name: \(user.inputName)")
                }
            }
        }
    }
}

#Preview {
    resultView()
}

