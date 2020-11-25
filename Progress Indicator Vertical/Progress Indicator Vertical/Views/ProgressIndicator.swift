//
//  ProgressIndicator.swift
//  Progress Indicator Vertical
//
//  Created by Debashish Das on 24/11/20.
//  Copyright © 2020 debashish. All rights reserved.
//

import SwiftUI

//MARK: - LeftArrow Shape

struct LeftArrow: Shape {
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    func path(in rect: CGRect) -> Path {
        let progressHeight = rect.height * (1 - progress)
        var path = Path()
        //print(progressHeight)
        print(progress)
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: progressHeight - 30))
        path.addCurve(to: CGPoint(x: 0, y: progressHeight + 30), control1: CGPoint(x: 0, y: progressHeight - 30), control2: CGPoint(x: -60, y: progressHeight))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        return path
    }
}

//MARK: - ProgressIndicator

struct ProgressIndicator: View {
    @State private var progress: CGFloat = 0.5
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(stride(from: 100, through: 0, by: -10)), id: \.self) { v in
                        Text("\(v) %")
                            .font(.system(size: 25))
                    }
                }
                HStack(spacing: 30) {
                        VStack {
                            ForEach(Array(stride(from: 0, through: 100, by: 2)), id: \.self) { v in
                                Rectangle()
                                    .fill(v % 10 == 0 ? Color.black : Color.blue)
                                    .offset(x: self.calculateOffset(index: v))
                                    .frame(width: v % 10 == 0 ? 40 : 25, height: 2)
                            }
                        }
                        ZStack(alignment: .top) {
                            LeftArrow(progress: progress)
                                .stroke(LinearGradient(gradient: .init(stops: [
                                    Gradient.Stop(color: .white, location: 0.0),
                                    Gradient.Stop(color: .blue, location: 0.5),
                                    Gradient.Stop(color: .white, location: 1.0)
                                ]), startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 40, height: 40)
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 20, height: 20)
                            }
                            .offset(x: -10)
                           .offset(y: (1 - progress) * 500 - 20)
                            .gesture(
                                DragGesture()
                                    .onChanged({ (v) in
                                        var yOffset = 1 - (v.location.y / 500)
                                        if yOffset > 1.0 { yOffset = 1.0 }
                                        if yOffset < 0.0 { yOffset = 0.0 }
                                        withAnimation {
                                            self.progress = yOffset
                                        }
                                    })
                            )
                            .shadow(radius: 5)
                        }
                        .frame(width: 4, height: 500)
                }
                VStack {
                    Text("Progress")
                        .font(.headline)
                    HStack(alignment: .firstTextBaseline) {
                        Text(String(format: "%.0f", progress * 100))
                            .font(.system(size: 40))
                            .animation(nil)
                        Text("%")
                            .fontWeight(.bold)
                    }
                }.padding(.leading)
                Spacer()
            }
        }.padding(.leading)
    }
    
    //MARK: - CalculateOffset
    
    private func calculateOffset(index: Int) -> CGFloat {
        let currentValue = (1 - progress) * 100
        let minRange = currentValue - 9
        let maxRange = currentValue + 9
        let range = minRange...maxRange
        if(range.contains(CGFloat(index))) {
            let distance = abs(currentValue - CGFloat(index))
            if distance == 0 {
                return -25
            } else {
                return -25 + 2 * distance
            }
        }
        return 0
    }
}


//MARK: - Previews

struct ProgressIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIndicator()
    }
}
