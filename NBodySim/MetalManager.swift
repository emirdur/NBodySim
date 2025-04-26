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
    static let shared = MetalManager() // singleton design pattern
    
    private let device: MTLDevice // represents GPU
    private let commandQueue: MTLCommandQueue // the work to send to the GPU
    private var pipelineState: MTLComputePipelineState! // compiled shader to be ran
    
    private init?() {
        guard let device = MTLCreateSystemDefaultDevice(), // guard used when you're 99% sure you won't enter the else block
              let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        self.device = device
        self.commandQueue = commandQueue
        
        do {
            let library = device.makeDefaultLibrary()
            let function = library?.makeFunction(name: "updateParticles")
            pipelineState = try device.makeComputePipelineState(function: function!)
        } catch {
            print("Failed to create pipeline state: \(error).")
            return nil
        }
    }
    
    func update(particlesBuffer: MTLBuffer, count: Int) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        
        encoder.setComputePipelineState(pipelineState)
        encoder.setBuffer(particlesBuffer, offset: 0, index: 0)
        
        let threadGroupSize = min(pipelineState.maxTotalThreadsPerThreadgroup, count)
        let threadGroups = MTLSize(width: (count + threadGroupSize - 1) / threadGroupSize, height: 1, depth: 1)
        let threadsPerGroup = MTLSize(width: threadGroupSize, height: 1, depth: 1)
        
        encoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadsPerGroup)
        encoder.endEncoding()
                
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
    }
    
    func makeParticlesBuffer(particles: [Particle]) -> MTLBuffer? {
        let size = particles.count * MemoryLayout<Particle>.stride
        return device.makeBuffer(bytes: particles, length: size, options: [])
    }
}
