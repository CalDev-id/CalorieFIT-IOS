//
//  CustomTapBar.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 21/03/25.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case message
    case bookmark
    case person
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    private var tabColor: Color {
        switch selectedTab {
        case .house:
            return .white
        case .message:
            return .white
        case .bookmark:
            return .white
        case .person:
            return .white
        }
    }
    
    private var tabName: String {
        switch selectedTab {
        case .house:
            return "Home"
        case .message:
            return "Message"
        case .bookmark:
            return "Bookmark"
        case .person:
            return "Profile"
        }
    }
    
    private var tabImage: String {
        switch selectedTab {
        case .house:
            return "home"
        case .message:
            return "chart"
        case .bookmark:
            return "saveoff"
        case .person:
            return "profileoff"
        }
    }
    
    private var tabImageOff: String {
        switch selectedTab {
        case .house:
            return "homeoff"
        case .message:
            return "chartoff"
        case .bookmark:
            return "saveoff"
        case .person:
            return "profileoff"
        }
    }

    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    HStack{
                        Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                            .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                            .foregroundColor(tab == selectedTab ? tabColor : .gray)
                            .font(.system(size: 20))
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    selectedTab = tab
                                }
                            }
                        if (selectedTab == tab){
                            Text(tabName).foregroundColor(.white).bold()
                        }
                    }.padding(10).background(selectedTab == tab ? Color.colorGreenPrimary : .clear).cornerRadius(8)
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(.white)
            .cornerRadius(20)
            .padding()
        }
    
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.house)).background(.blue)
}
