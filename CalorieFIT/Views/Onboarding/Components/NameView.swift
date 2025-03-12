//
//  NameView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//
import SwiftUI

struct NameView: View {
    @Binding var inputName: String
    
    var body: some View {
        VStack {
            TextField("Enter Your Name", text: $inputName)
                .frame(height: 80)
                .foregroundColor(.black)
                .font(.system(size: 30))
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.colorGrayInput)
                .cornerRadius(5)
                .shadow(radius: 1)
                .padding()
        }
    }
}
