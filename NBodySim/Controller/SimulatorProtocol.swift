//
//  SimulatorProtocol.swift
//  NBodySim
//
//  Created by Emir Durakovic on 4/27/25.
//

import Foundation

protocol SimulatorProtocol: ObservableObject {
    var particles: [Particle] { get set }
    func update()
}
