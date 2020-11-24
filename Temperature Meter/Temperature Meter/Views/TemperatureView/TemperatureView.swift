//
//  TemperatureView.swift
//  Temperature Meter
//
//  Created by Debashish Das on 17/09/20.
//  Copyright © 2020 debashish. All rights reserved.
//

import SwiftUI

//MARK: - Triangle Shape

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

//MARK: - Temperature View

struct TemperatureView: View {
        let startValue: CGFloat = 15.0
        let lastValue: CGFloat = 40.0
        let totalValue: CGFloat = 100.0
        @State private var angle: Double = 0.0
        @State private var value: Double = 0.0
        var body: some View {
            VStack {
                Text("Select Temperature")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("In ℃")
                    .font(.headline)
                    .foregroundColor(Color.black.opacity(0.4))
                ZStack {
                            Circle()
                                .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
                                .frame(width: 300, height: 300)
                            Circle()
                                .trim(from: startValue / totalValue, to: lastValue / totalValue)
                                .stroke(AngularGradient(gradient: .init(colors: [.green, .yellow, .red]), center: .center, startAngle: .degrees(50), endAngle: .degrees(150)), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                                .frame(width: 300, height: 300)
                                .rotationEffect(.degrees(-190))
                            Circle()
                                .stroke(LinearGradient(gradient: .init(stops: [
                                    Gradient.Stop(color: .red, location: 0.0),
                                    Gradient.Stop(color: .yellow, location: 0.5),
                                    Gradient.Stop(color: .green, location: 1.0)
                                ]), startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 4, lineCap: .butt,dash: [2, 12]))
                                .frame(width: 240, height: 240)
                            Circle()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.4), radius: 15, x: -5, y: 3)
                                .frame(width: 180, height: 180)
                            Circle()
                                .fill(Color.black.opacity(0.1))
                                .frame(width: 40, height: 40)
                            Circle()
                                .fill(Color.green.opacity(0.5))
                                .frame(width: 20, height: 20)
                            Circle()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 3, x: -3, y: 2)
                                .scaleEffect(1.5)
                                .offset(x: 150)
                                .rotationEffect(.degrees(angle))
                                .gesture(DragGesture().onChanged(self.dragHandle(value:)))
                                .frame(width: 20, height: 20)
                                .rotationEffect(.degrees(-190))
                            Triangle()
                                .fill(Color.white)
                                .offset(x: 92)
                                .rotationEffect(.degrees(angle))
                                .frame(width: 30, height: 30)
                                .rotationEffect(.degrees(-190))
                                
                        }.onAppear {
                            self.angle = Double(self.startValue / self.totalValue) * 360
                        }
                .padding([.top, .bottom], 30)
                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text(String(format: "%0.f", value))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    Text("℃")
                        .font(.body)
                }
                Spacer()
            }.padding()
        }

        //MARK: - DragHand
    
        private func dragHandle(value: DragGesture.Value) {
            let vector = CGVector(dx: value.location.x, dy: value.location.y)
            let radian = atan2(vector.dy - 10, vector.dx - 10)
            let fixedRadian = radian < 0 ? radian + 2 * .pi : radian
            let degree = fixedRadian * 180 / .pi
            let totalValue = degree / 360 * 100
            if totalValue >= startValue && totalValue <= lastValue {
                self.value = Double(totalValue)
                withAnimation {
                    self.angle = Double(degree)
                }
            }
        }
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureView()
    }
}
