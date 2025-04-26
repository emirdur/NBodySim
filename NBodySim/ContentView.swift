//
//  ContentView.swift
//  NBodySim
//
//  Created by Emir Durakovic on 4/26/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var simulator = Simulator(n: 100)
    
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
                }
            }
            .frame(width: 500, height: 500)
            .background(Color.white)
        }
    }
}
