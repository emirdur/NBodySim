//
//  Shaders.metal
//  NBodySim
//
//  Created by Emir Durakovic on 4/26/25.
//

#include <metal_stdlib>
using namespace metal;

struct Particle {
    float2 position;
    float2 velocity;
    float mass;
};

kernel void updateParticles(device Particle* particles [[buffer(0)]], uint id [[thread_position_in_grid]]) {
    if (id >= 1000) return;
    particles[id].position += particles[id].velocity * 0.016;
}

