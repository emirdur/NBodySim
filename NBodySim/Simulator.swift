//
//  Simulator.swift
//  NBodySim
//
//  Created by Emir Durakovic on 4/26/25.
//

import Foundation
import simd

class Simulator: ObservableObject {
    @Published var particles: [Particle] = []
    let gravitationalConstant: Float = 0.001
    let dt: Float = 0.016 // 60 fps => 1/60s = 0.016s
    var timer: Timer?
    
    init(n: Int) {
        self.particles = (0..<n).map {
            _ in Particle(
                position: SIMD2<Float>(
                    Float.random(in: 0..<500), // random x vector position [0, 500)
                    Float.random(in: 0..<500) // random y vector position
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
        
        start()
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(dt), repeats: true) { [weak self] _ in
            self?.updateParticles()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateParticles() {
        for i in 0..<particles.count {
            if particles[i].position.x <= 0 || particles[i].position.x >= 500 {
                particles[i].velocity.x *= -1
                particles[i].position.x = min(max(particles[i].position.x, 0), 500)
            }
            
            if particles[i].position.y <= 0 || particles[i].position.y >= 500 {
                particles[i].velocity.y *= -1
                particles[i].position.y = min(max(particles[i].position.y, 0), 500)
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
    }
    
    deinit {
        stop()
    }
}
