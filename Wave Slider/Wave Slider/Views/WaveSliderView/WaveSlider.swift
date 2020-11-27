//
//  WaveSlider.swift
//  Wave Slider
//
//  Created by Debashish Das on 27/11/20.
//  Copyright © 2020 debashish. All rights reserved.
//

import SwiftUI

//MARK: - Wave Shape

private struct Wave: Shape {
    var progress: CGFloat
    var amplitude: CGFloat = 15
    var WaveLength: CGFloat = 15
    var phase: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let progressHeight = (1 - progress) * height
        
        path.move(to: CGPoint(x: 0, y: progressHeight))
        for x in stride(from: 0, to: width + 15, by: 1) {
            let relativeX = x / WaveLength
            let y = progressHeight + sin(phase + relativeX) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: progressHeight))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: progressHeight))
        return path
    }
}

//MARK: - WaveSlider

struct WaveSlider: View {
    @State private var progress: CGFloat = 0.5
    @State private var animated = false
    @State private var firstBubble = false
    @State private var secondBubble = false
    @State private var firstMove = false
    @State private var secondMove = false
    private let width: CGFloat = 200, height: CGFloat = 400
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ZStack(alignment: .bottom) {
                ZStack {
                    Capsule()
                    .stroke(Color.white, lineWidth: 10)
                    .frame(width: width + 10, height: height + 10)
                    Wave(progress: progress, phase: animated ? 0 : .pi * 2)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.red]), startPoint: .top, endPoint: .bottom))
                    .frame(width: width, height: height)
                    .clipShape(Capsule())
                    .gesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged({ (value) in
                                    self.progress = 1 - (value.location.y / self.height)
                                    if self.progress > 1 { self.progress = 1.0 }
                                    if self.progress < 0.01 { self.progress = 0.01 }
                            })
                    )
                }

                ZStack() {
                    HStack(spacing: 1) {
                        Text("\(Int(progress * 100))")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        Text("%")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .offset(y: -4)
                    }
                }
                .frame(width: width + 5, height: progress * height)
            }
            
            //MARK: Bubbles
            
            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 10, height: 10)
                .scaleEffect(firstBubble ? 1.5 : 0.1)
                .offset(x: width / 3.5, y: height / 3.5)
            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 10, height: 10)
                .scaleEffect(secondBubble ? 1.5 : 0.1)
                .offset(x: -width / 3.5, y: height / 2.5)
            Circle()
                .fill(Color.white.opacity(0.7))
                .frame(width: 10, height: 10)
                .opacity(self.firstMove ? 0 : 0.5)
                .offset(x: width / 3.5, y: self.firstMove ? height / 12 : height / 5)
            Circle()
                .fill(Color.white.opacity(0.7))
                .frame(width: 10, height: 10)
                .opacity(self.secondMove ? 0 : 0.5)
                .offset(x: -width / 3.5, y: self.secondMove ? height / 12 : height / 3)
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                self.animated.toggle()
            }
            withAnimation(Animation.easeInOut(duration: 1.0).delay(0.7).repeatForever(autoreverses: false)) {
                self.firstBubble.toggle()
            }
            withAnimation(Animation.easeInOut(duration: 1.0).delay(0.5).repeatForever(autoreverses: false)) {
                self.secondBubble.toggle()
            }
            withAnimation(Animation.easeInOut(duration: 0.7).delay(0.3).repeatForever(autoreverses: false)) {
                self.firstMove.toggle()
            }
            withAnimation(Animation.easeInOut(duration: 0.5).delay(0.1).repeatForever(autoreverses: false)) {
                self.secondMove.toggle()
            }
        }
    }
}

struct WaveSlider_Previews: PreviewProvider {
    static var previews: some View {
        WaveSlider()
    }
}
