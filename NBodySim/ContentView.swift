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
                    
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: position.x - circleSize / 2,
                            y: position.y - circleSize / 2,
                            width: circleSize,
                            height: circleSize
                        )),
                        with: .color(.blue)
                    )
                }
            }
            .frame(width: 500, height: 500)
            .background(Color.white)
        }
    }
}
