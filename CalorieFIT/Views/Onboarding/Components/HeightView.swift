
import SwiftUI
import AudioToolbox

struct HeightView: View {
    @Binding var inputHeight: Double
    @State var offset: CGFloat
    
    let startHeight = 120
    let maxHeight = 200
    let step = 2
    let stepWidth: CGFloat = 20
    
    init(inputHeight: Binding<Double>) {
        self._inputHeight = inputHeight
        let middleValue = 160 // Target angka tengah
        let middleOffset = CGFloat((middleValue - startHeight) / step) * 20
        self._offset = State(initialValue: middleOffset)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(getHeight())")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                Text("cm")
                    .foregroundColor(.white)
            }
            
            let pickerCount = (maxHeight - startHeight) / step / 5
            
            customSlider(pickerCount: pickerCount, offset: $offset, startHeight: startHeight, maxHeight: maxHeight, step: step) {
                HStack(spacing: 0) {
                    ForEach(0...pickerCount, id: \ .self) { index in
                        VStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 1, height: 30)
                            Text("\(startHeight + (index * 10))")
                                .font(.caption2)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: stepWidth)
                        
                        ForEach(1...4, id: \ .self) { _ in
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 1, height: 15)
                                .frame(width: stepWidth)
                        }
                    }
                }
                .offset(x: (getRect().width + 17) / 2)
                .padding(.trailing, getRect().width - 30)
            }
            .frame(height: 50)
            .overlay(
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 4, height: 50)
                    .offset(x: 0.8, y: -30)
            )
            .padding()
        }
        .onChange(of: offset) { _ in
            inputHeight = Double(getHeight()) ?? 0
        }
    }
    
    func getHeight() -> String {
        let progress = offset / stepWidth
        let value = startHeight + (Int(progress) * step)
        return "\(min(max(value, startHeight), maxHeight))"
    }
}

struct customSlider<Content: View>: UIViewRepresentable {
    var content: Content
    @Binding var offset: CGFloat
    let startHeight: Int
    let maxHeight: Int
    let step: Int
    
    init(pickerCount: Int, offset: Binding<CGFloat>, startHeight: Int, maxHeight: Int, step: Int, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._offset = offset
        self.startHeight = startHeight
        self.maxHeight = maxHeight
        self.step = step
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        let swiftUIView = UIHostingController(rootView: content).view!
        let width = CGFloat(((maxHeight - startHeight) / step) * 20) + (getRect().width - 30)
        swiftUIView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        
        scrollView.backgroundColor = UIColor.clear
        swiftUIView.backgroundColor = .clear
        scrollView.addSubview(swiftUIView)
        scrollView.contentSize = swiftUIView.frame.size
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        
        let middleOffset = CGFloat((160 - startHeight) / step) * 20
        scrollView.contentOffset.x = middleOffset
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: customSlider
        init(parent: customSlider) {
            self.parent = parent
        }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let minOffset: CGFloat = 0
            let maxOffset: CGFloat = CGFloat((parent.maxHeight - parent.startHeight) / parent.step) * 20
            
            DispatchQueue.main.async {
                self.parent.offset = min(max(scrollView.contentOffset.x, minOffset), maxOffset)
            }
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            snapToNearestValue(scrollView)
        }
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                snapToNearestValue(scrollView)
            }
        }
        func snapToNearestValue(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            let value = (offset / 20).rounded(.toNearestOrAwayFromZero)
            scrollView.setContentOffset(CGPoint(x: CGFloat(value * 20), y: 0), animated: false)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(1157)
        }
    }
}

func getRect() -> CGRect {
    return UIScreen.main.bounds
}


#Preview {
    OnboardingView()
}
