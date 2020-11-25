//
//  LightMeter.swift
//  Light Meter
//
//  Created by Debashish Das on 17/09/20.
//  Copyright © 2020 debashish. All rights reserved.
//

import SwiftUI

//MARK: - Light Slider

struct LightSlider: Shape {
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let heightToIncrease = (1 - progress) * rect.height
        path.move(to: CGPoint(x: rect.minX, y: heightToIncrease + 30))
        path.addCurve(to: CGPoint(x: rect.minX + 30, y: heightToIncrease), control1: CGPoint(x: rect.minX, y: heightToIncrease + 30), control2: CGPoint(x: rect.minX, y: heightToIncrease))
        path.addLine(to: CGPoint(x: rect.maxX, y: heightToIncrease))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

//MARK: - LightMeter

struct LightMeter: View {
    private let width: CGFloat = 150
    private let height: CGFloat = 350
    @State private var progress: CGFloat = 0.5
    @State private var isToggled = false
    var body: some View {
        ZStack {
            Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
            VStack {
                Text("Light ")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                HStack(alignment: .center) {
                    ZStack(alignment: .top) {
                        ZStack {
                            Rectangle()
                                .stroke(Color.white, lineWidth: 0.5)
                                .frame(width: width, height: height)
                                .background(Color.white)
                            LightSlider(progress: progress)
                                .fill(LinearGradient(gradient: Gradient(colors: [.white, Color.green.opacity(0.5)]), startPoint: .top, endPoint: .bottom))
                                .frame(width: width, height: height)
                                .animation(.default)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: width * 0.3))
                        .shadow(color: Color.black.opacity(0.3), radius: 15, x: -3, y: 3)
                        
                        //MARK:  Knob View
                        
                        ZStack {
                            Circle()
                                .fill(Color.white)
                            .shadow(radius: 5)
                            .frame(width: 40, height: 40)
                            Circle()
                                .fill(Color.green.opacity(0.5))
                            .frame(width: 20, height: 20)
                        }
                        .offset(x: width / 2 - 5)
                        .offset(y: calculateYOffset())
                        .gesture(
                            DragGesture().onChanged(handleGesture(value:))
                        )
                    }.padding(.leading)
                    GeometryReader { geo in
                        HStack(spacing: 0) {
                            VStack(alignment: .leading) {
                                ForEach(0..<11) { index in
                                    Text("\(String((10 - index) * 10)) %")
                                        .font(.system(size: 20))
                                        .position(x: geo.size.width / 3, y: (geo.size.height / 10) / 2)
                                }
                            }
                            VStack(alignment: .leading) {
                                ForEach(0..<11) { index in
                                        Rectangle()
                                            .fill(Color.blue.opacity(0.5))
                                            .frame(width: 20, height: 1)
                                            .position(x: geo.size.width / 4, y: (geo.size.height / 10) / 2)
                                }
                            }
                        }
                    }
                }.padding(.horizontal).frame(height: height)
                HStack {
                    VStack(spacing: 5) {
                        Text("Auto Adjust")
                            .font(.caption)
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.black.opacity(0.1))
                                .shadow(radius: 4)
                                .frame(width: 60, height: 15)
                            Capsule()
                                .fill(Color.green.opacity(0.5))
                                .shadow(color: Color.black.opacity(0.5), radius: 3, x: -3, y: 2)
                                .offset(x: isToggled ? 30 : 0)
                                .onTapGesture {
                                    withAnimation {
                                        self.isToggled.toggle()
                                    }
                                }
                                .frame(width: 30, height: 15)
                        }
                    }
                    Spacer()
                    Text("\(String(format: "%0.f", progress * 100)) %")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .animation(nil)
                }.padding().padding(.horizontal, 30)
                Spacer()
            }
        }
    }
    
    //MARK: - HandleGesture
    
    private func handleGesture(value: DragGesture.Value) {
        var yOffset = 1 - (value.location.y / self.height)
        withAnimation {
            if yOffset > 1.0 { yOffset = 1.0 }
            else if yOffset < 0.0 { yOffset = 0.0 }
            self.progress = yOffset
        }
    }
    
    //MARK: - CalculateYOffSet
    
    private func calculateYOffset() -> CGFloat {
        (1 - progress) * height - 20
    }
}

//MARK: - Preview

struct LightMeter_Previews: PreviewProvider {
    static var previews: some View {
        LightMeter()
    }
}
