//
//  MetalManager.swift
//  NBodySim
//
//  Created by Emir Durakovic on 4/26/25.
//

import Foundation
import Metal
import simd

final class MetalManager {
    static let shared = MetalManager()
    
    private let device: MTLDevice // represents GPU
    private let commandQueue: MTLCommandQueue // the work to send to the GPU
    private var pipelineState: MTLComputePipelineState? // compiled shader to be run
    
    // initialization needs ? since declarations above can fail
    private init?() {
        guard let device = MTLCreateSystemDefaultDevice(), // since the GPU device may not be fetched, we use a guard to safely unwrap the optional value and have an early exit if it's nil
              let commandQueue = device.makeCommandQueue() else {
            return nil // nil object
        }
        
        self.device = device
        self.commandQueue = commandQueue
        
        do {
            let library = device.makeDefaultLibrary() // loads all metal files
            if let function = library?.makeFunction(name: "updateParticles") {
                pipelineState = try device.makeComputePipelineState(function: function)
            } else {
                print("Failed to find function.")
            }
        } catch {
            print("Failed to create pipeline state: \(error).")
            return nil
        }
    }
    
    func update(particlesBuffer: MTLBuffer, particleCount: Int) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeComputeCommandEncoder(),
              let pipelineState = pipelineState else {
            print("Failed to create command buffer, encoder, or pipeline state.")
            return
        }
        
        // encoder - prepares the instructions for the GPU (which shader to use, which buffers to use, how to execute the instructions)
        // buffer - the data the GPU will process
        
        encoder.setComputePipelineState(pipelineState)
        encoder.setBuffer(particlesBuffer, offset: 0, index: 0)
        
        let threadGroupSize = min(pipelineState.maxTotalThreadsPerThreadgroup, particleCount) // each particle is allocated a thread, unless you exceed the maximum amount of threads per thread group
        let threadGroups = MTLSize(width: (particleCount + threadGroupSize - 1) / threadGroupSize, height: 1, depth: 1)
        let threadsPerGroup = MTLSize(width: threadGroupSize, height: 1, depth: 1) // defines how many threads you need in 3D space (in reality we're just using the 1D space since we have a list of particles)
        
        encoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadsPerGroup)
        encoder.endEncoding() // done adding commands, GPU can start executing them
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted() // blocks CPU from running until GPU is finished
    }
    
    func makeParticlesBuffer(particles: [Particle]) -> MTLBuffer? {
        let size = particles.count * MemoryLayout<Particle>.stride // kind of like sizeof(Particle) * number of particles
        return device.makeBuffer(bytes: particles, length: size, options: [])
    }
}
