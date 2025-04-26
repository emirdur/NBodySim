//
//  Particle.swift
//  NBodySim
//
//  Created by Emir Durakovic on 4/26/25.
//

import Foundation
import simd

struct Particle {
    var position: SIMD2<Float> // SIMD2 is a vector of two 32-bit floating-point elements
    var velocity: SIMD2<Float>
    var mass: Float
}
