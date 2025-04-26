//
//  MTLSimulator.swift
//  NBodySim
//
//  Created by Emir Durakovic on 4/26/25.
//

import Foundation
import Metal
import simd

final class MTLSimulator: ObservableObject {
    @Published var particles: [Particle]
    
    private var particlesBuffer: MTLBuffer?
    private let metalManager = MetalManager.shared
    
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
        self.particlesBuffer = metalManager?.makeParticlesBuffer(particles: particles)
    }
    
    func update() {
        guard let particlesBuffer = particlesBuffer else { return }
        metalManager?.update(particlesBuffer: particlesBuffer, particleCount: particles.count)
        
        // copy back to CPU
        let pointer = particlesBuffer.contents().bindMemory(to: Particle.self, capacity: particles.count)
        particles = Array(UnsafeBufferPointer(start: pointer, count: particles.count))
    }
}
