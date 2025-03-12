//
//  HeightView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI

struct HeightView: View {
    @Binding var inputHeight: Double
    let minHeight: Double = 120
    let maxHeight: Double = 220
    var body: some View {
        VStack{
            HStack() {
                Text(String(inputHeight))
                    .font(.system(size: 50, weight: .bold))
                Text("cm")
            }
            ZStack {
                RulerView()
                    .frame(height: 60)
                    .padding(.horizontal, 20)

                            // Moving Indicator
                Rectangle()
                    .frame(width: 4, height: 60)
                    .foregroundColor(Color.colorGreenPrimary)
                    .offset(x: mapValueToPosition(inputHeight))
                }

                        // Slider for height input
                Slider(value: $inputHeight, in: minHeight...maxHeight, step: 1)
                    .padding(.horizontal, 20)
                    .foregroundStyle(Color.gray)
            
        }
    }
    private func mapValueToPosition(_ value: Double) -> CGFloat {
        let width: CGFloat = 300 // Adjust based on screen width
        let range = maxHeight - minHeight
        let ratio = CGFloat((value - minHeight) / range)
        return ratio * width - (width / 2)
    }
}

struct RulerView: View {
    let minHeight: Double = 120
    let maxHeight: Double = 220
    let step: Double = 5

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let width = size.width
                let height = size.height
                let tickSpacing = width / CGFloat((maxHeight - minHeight) / step)

                for i in stride(from: minHeight, through: maxHeight, by: step) {
                    let x = (CGFloat(i - minHeight) / CGFloat(maxHeight - minHeight)) * width

                    let tickHeight: CGFloat = (i.truncatingRemainder(dividingBy: 10) == 0) ? 30 : 10
                    let tickY = height - tickHeight

                    // Draw tick marks
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: x, y: height))
                            path.addLine(to: CGPoint(x: x, y: tickY))
                        },
                        with: .color(.gray.opacity(0.5)),
                        lineWidth: 2
                    )

                    // Draw text labels for every 10 cm
                    if i.truncatingRemainder(dividingBy: 10) == 0 {
                        let text = Text("\(Int(i))").font(.footnote).foregroundColor(.black)
                        context.draw(text, at: CGPoint(x: x, y: tickY - 15))
                    }
                }
            }
        }
    }
}
