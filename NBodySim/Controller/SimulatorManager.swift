//
//  SimulatorManager.swift
//  NBodySim
//
//  Created by Emir Durakovic on 4/27/25.
//

import Foundation

final class SimulatorManager: ObservableObject {
    enum SimulatorType {
        case cpu(Simulator)
        case gpu(MTLSimulator)
        
        var particles: [Particle] {
            switch self {
            case .cpu(let sim): return sim.particles
            case .gpu(let sim): return sim.particles
            }
        }
        
        mutating func update() {
            switch self {
            case .cpu(let sim):
                sim.update()
                self = .cpu(sim)
            case .gpu(let sim):
                sim.update()
                self = .gpu(sim)
            }
        }
    }
    
    @Published private(set) var simulator: SimulatorType
    
    init(useMetal: Bool, n: Int) {
        if useMetal {
            self.simulator = .gpu(MTLSimulator(n: n))
        } else {
            self.simulator = .cpu(Simulator(n: n))
        }
    }
    
    func update() {
        simulator.update()
    }
    
    var particles: [Particle] {
        simulator.particles
    }
}

