//
//  MTLSimulator.swift
//  NBodySim
//
//  Created by Emir Durakovic on 4/26/25.
//

import Foundation
import Metal
import simd

final class MTLSimulator: ObservableObject, SimulatorProtocol {
    @Published var particles: [Particle]
    
    private var particlesBuffer: MTLBuffer?
    private let metalManager = MetalManager.shared
    
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
        self.particlesBuffer = metalManager?.makeParticlesBuffer(particles: particles)
    }
    
    func update() {
        guard let particlesBuffer = particlesBuffer else { return }
        
        let gravitationalConstant: Float = 0.001
        let dt: Float = 1/120
        
        
        let start = DispatchTime.now()
        
        metalManager?.update(particlesBuffer: particlesBuffer, particleCount: particles.count, gravitationalConstant: gravitationalConstant, dt: dt)
        
        // copy back to CPU
        let pointer = particlesBuffer.contents().bindMemory(to: Particle.self, capacity: particles.count)
        particles = Array(UnsafeBufferPointer(start: pointer, count: particles.count))

        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let milliSeconds = Double(nanoTime) / 1_000_000
        print("GPU Frame Time: \(milliSeconds) ms")
    }
}
