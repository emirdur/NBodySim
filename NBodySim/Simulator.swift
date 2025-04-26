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
    let gravity: Float = 9.8
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
                    Float.random(in: -1...1), // random x velocity [-1, 1]
                    Float.random(in: -1...1) // random y velocity
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
            // v = v + at
            particles[i].velocity.y += gravity * dt
            // x = x + vt
            particles[i].position += particles[i].velocity * dt
        }
    }
    
    deinit {
        stop()
    }
}
