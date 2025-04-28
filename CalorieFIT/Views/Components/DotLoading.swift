//
//  DotLoading.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 26/04/25.
//

import SwiftUI

struct DotLoadingView: View {
    @State private var scaleEffect: CGFloat = 0.5
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .scaleEffect(scaleEffect)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(0.2 * Double(index)),
                        value: scaleEffect
                    )
            }
        }
        .onAppear {
            scaleEffect = 1.0
        }
    }
}
