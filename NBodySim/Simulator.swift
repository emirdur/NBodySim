//
//  Simulator.swift
//  NBodySim
//
//  Created by Emir Durakovic on 4/26/25.
//

import Foundation
import simd

final class Simulator: ObservableObject {
    @Published var particles: [Particle] = []
    let gravitationalConstant: Float = 0.001
    let dt: Float = 1/120 // 60 fps => 1/60s = 0.016s 120 fps => 1/120s = 0.00833
    
    init(n: Int) {
        self.particles = (0..<n).map {
            _ in Particle(
                position: SIMD2<Float>(
                    Float.random(in: 0..<430), // random x vector position [0, 500)
                    Float.random(in: 0..<932) // random y vector position
                ),
                velocity: SIMD2<Float>(
                    Float.random(in: -10...10), // random x velocity [-10, 10]
                    Float.random(in: -10...10) // random y velocity
                ),
                mass: Float(
                    Float.random(in: 1...10) // [1, 10]
                )
            )
        }
    }

    func update() {
        let start = DispatchTime.now()
        
        for i in 0..<particles.count {
            if particles[i].position.x <= 0 || particles[i].position.x >= 430 {
                particles[i].velocity.x *= -1
                particles[i].position.x = min(max(particles[i].position.x, 0), 430)
            }
            
            if particles[i].position.y <= 0 || particles[i].position.y >= 932 {
                particles[i].velocity.y *= -1
                particles[i].position.y = min(max(particles[i].position.y, 0), 932)
            }
            
            var totalForce = SIMD2<Float>(0, 0)
            
            for j in 0..<particles.count where j != i {
                let direction = particles[i].position - particles[j].position
                let distanceSquared = max(length_squared(direction), 0.01)
                let forceMagnitude = gravitationalConstant * particles[i].mass * particles[j].mass / distanceSquared
                totalForce += forceMagnitude * normalize(direction)
            }
            
            // a = F / m
            let acceleration = totalForce / particles[i].mass
            
            // v = v + at
            particles[i].velocity += acceleration * dt
            // x = x + vt
            particles[i].position += particles[i].velocity * dt
        }
        
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let milliSeconds = Double(nanoTime) / 1_000_000
        print("CPU Frame Time: \(milliSeconds) ms")
    }
}
