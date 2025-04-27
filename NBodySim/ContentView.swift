//
//  ContentView.swift
//  NBodySim
//
//  Created by Emir Durakovic on 4/26/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var simulator = Simulator(n: 250)
    
    var body: some View {
        VStack {
            Canvas { context, size in
                for particle in simulator.particles {
                    let circleSize: CGFloat = 10
                    let position = CGPoint(
                        x: CGFloat(particle.position.x),
                        y: CGFloat(particle.position.y)
                    )
                    
                    let skyBlue = Color(red: 0.4627, green: 0.8392, blue: 1.0)
                    let normalizedMass = min(max(particle.mass / 10.0, 0.0), 1.0)
                    let color = skyBlue.opacity(Double(normalizedMass))
                    
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: position.x - circleSize / 2,
                            y: position.y - circleSize / 2,
                            width: circleSize,
                            height: circleSize
                        )),
                        with: .color(color)
                    )
                    
                    let velocityScale: CGFloat = 0.5
                    let velocityEnd = CGPoint(
                        x: position.x + CGFloat(particle.velocity.x) * velocityScale,
                        y: position.y + CGFloat(particle.velocity.y) * velocityScale
                    )
                    
                    var path = Path()
                    path.move(to: position)
                    path.addLine(to: velocityEnd)
                    
                    context.stroke(
                        path,
                        with: .color(.black),
                        lineWidth: 1
                    )
                }
            }
            .frame(width: 430, height: 932)
            .background(Color.white)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
                    simulator.update()
                }
            }
        }
    }
}
