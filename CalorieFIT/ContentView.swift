//
//  ContentView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView{
            HomeScreen()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            resultView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
            
        }
        .accentColor(Color.colorGreenPrimary)
                .background(.white)
    }
}

#Preview {
    ContentView()
}
