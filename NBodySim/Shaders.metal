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
kernel void update(device Particle* particles [[buffer(0)]], uint id [[thread_position_in_grid]], constant float& gravitationalConstant [[buffer(1)]], constant float& dt [[buffer(2)]], constant uint& particleCount [[buffer(3)]]) {
    if (id >= particleCount) return;
    
    if (particles[id].position.x <= 0 || particles[id].position.x >= 430) {
        particles[id].velocity.x *= -1;
        particles[id].position.x = min(max(particles[id].position.x, 0.0), 430.0);
    }
    
    if (particles[id].position.y <= 0 || particles[id].position.y >= 932) {
        particles[id].velocity.y *= -1;
        particles[id].position.y = min(max(particles[id].position.y, 0.0), 932.0);
    }
    
    float2 totalForce = float2(0.0, 0.0);
    
    for (uint j = 0; j < particleCount; j++) {
        if (j != id) {
            float2 direction = particles[id].position - particles[j].position;
            float distanceSquared = max(length(direction) * length(direction), 0.01);
            float forceMagnitude = gravitationalConstant * particles[id].mass * particles[j].mass / distanceSquared;
            totalForce += forceMagnitude * normalize(direction);
        }
    }
    
    float2 acceleration = totalForce / particles[id].mass;
    particles[id].velocity += acceleration * dt; // v = v + at
    particles[id].position += particles[id].velocity * dt; // x = x + vt
}
