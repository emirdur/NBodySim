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


// kernel - Metal compute kernel which is a function designed to be executed in parallel on the GPU
// particles data array is stored in the GPUs memory and is bound to the first buffer passed to the kernel
kernel void updateParticles(device Particle* particles [[buffer(0)]], uint id [[thread_position_in_grid]]) {
    if (id >= 1000) return;
    float dt = 0.016;
    particles[id].position += particles[id].velocity * dt;
}
