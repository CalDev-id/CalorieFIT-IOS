//
//  BTNSecondary.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 01/04/25.
//

import SwiftUI

struct SecondaryBTN: View {
    var name: String
    var todo: () -> Void  // Change todo to a closure

    var body: some View {
        Button(action: {
            todo()  // Call the closure when the button is pressed
        }) {
            HStack {
                Text(name)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Image("btn1")
                Spacer()
                Image("btn2")
            }
            .padding()
        }
        .frame(width: 180, height: 50)
        .background(Color.greenSecondary)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

#Preview {
    SecondaryBTN(name: "Continue", todo: {})
}
