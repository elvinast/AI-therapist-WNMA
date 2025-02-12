//
//  CirclularSlider.swift
//  Radiant
//
//  Created by Ben Dreyer on 7/17/23.
//

import SwiftUI

struct CirclularSlider: View {
    @Binding var sliderValue: Double
    
    var body: some View {
        ZStack {
//            Rectangle()
//                .fill(Color.init(red: 34/255, green: 30/255, blue: 47/255))
//                .edgesIgnoringSafeArea(.all)
            
            SliderControlView(sliderValue: $sliderValue)
        }
    }
}

//struct CirclularSlider_Previews: PreviewProvider {
//    @State private var val: CGFloat = 5.0
//
//    static var previews: some View {
//        CirclularSlider($val)
//    }
//}


struct SliderControlView: View {
    @Binding var sliderValue: Double
    @State var angleValue: CGFloat = 180.0
    
    var radiusVal: CGFloat?
    
    let config = Config(minimumValue: 0.0, maximumValue: 10.0, totalValue: 10.0, knobRadius: 10.0, radius: 45.0)
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(Color.clear)
                .frame(width: config.radius * 2, height: config.radius * 2)
                .scaleEffect(1.2)
                
            
            Circle()
                .stroke(Color.white,
                        style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [3, 75.54]))
                .frame(width: config.radius * 2, height: config.radius * 2)
            
            Circle()
                .trim(from: 0.0, to: sliderValue / config.totalValue)
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: config.radius * 2, height: config.radius * 2)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .fill(Color.blue)
                .frame(width: config.knobRadius * 2, height: config.knobRadius * 2)
                .padding(10)
                .offset(y: -config.radius)
                .rotationEffect(Angle.degrees(Double(angleValue)))
                .gesture(DragGesture(minimumDistance: 0.0)
                                            .onChanged({ value in
                                                change(location: value.location)
                                            }))
            
            Text("\(String.init(format: "%.0f", sliderValue))")
                .font(.system(size: 40))
                .foregroundColor(.white)
                
        }
    }
    
    private func change(location: CGPoint) {
        //creating vector from location point
        let vector = CGVector(dx: location.x, dy: location.y)
        
        // geting angle in radian need to subtract the knob radius and padding
        let angle = atan2(vector.dy - (config.knobRadius + 10), vector.dx - (config.knobRadius + 10)) + .pi/2.0
        // convert angle range from (-pi to pi) to (0 to 2pi)
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        // convert angle value to temperature value
        let value = fixedAngle / (2.0 * .pi) * config.totalValue
        
        if value >= config.minimumValue && value <= config.maximumValue {
            sliderValue = value
            angleValue = fixedAngle * 180 / .pi // converting to degree
        }
    }
}


struct Config {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
}
