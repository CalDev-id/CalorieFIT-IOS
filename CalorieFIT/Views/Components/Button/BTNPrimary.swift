//
//  BTNPrimary.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

import SwiftUI

struct PrimaryBTN: View {
    var name: String
    var todo: () -> Void  // Change todo to a closure

    var body: some View {
        Button(action: {
            todo()  // Call the closure when the button is pressed
        }) {
            Text(name)
                .foregroundColor(.black)
                .fontWeight(.semibold)
                .frame(width: UIScreen.main.bounds.width - 40, height: 45)
        }
        .background(Color.colorGreenPrimary)
        .cornerRadius(10)
    }
}

#Preview {
    PrimaryBTN(name: "Take", todo: {})
}
