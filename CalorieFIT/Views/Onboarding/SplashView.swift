//
//  SplashView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 01/04/25.
//

import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool
    
    var body: some View {
        VStack {
            Image("calorify_logo_text")
                .resizable()
                .frame(width: 161, height: 161)
                .offset(y: 20)
            Image("onboard")
            HStack {
                Text("Track Your ")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Nutrition")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text(",")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, -5)
            }
            .multilineTextAlignment(.center)
            
            HStack {
                Text("Transform Your ")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Health")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .multilineTextAlignment(.center)
            
            Text("Stay healthy by tracking every meal.")
                .foregroundStyle(.secondary)
                .padding(.bottom, 50)
            Group{
                HStack {
                    Text("Continue")
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
            .onTapGesture {
                showSplash = !showSplash
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity)
        .padding()
        .offset(y:-50)
    }
}

//#Preview {
//    SplashView()
//}
