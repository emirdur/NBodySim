# N-body Simulation

## Overview

The N-body problem is a classical physics problem that involves simulating the motion of `N` objects under the influence of gravitational forces. This simulation computes the gravitational forces between each pair of particles, updating their positions and velocities over time based on Newton’s law of gravitation.

### Gravitational Formula

The gravitational force between two bodies is given by the following formula:

$$
F = \frac{G \cdot m_1 \cdot m_2}{r^2}
$$

Where:
- \( F \) is the force between the bodies.
- \( G \) is the gravitational constant.
- \( m_1 \) and \( m_2 \) are the masses of the two particles.
- \( r \) is the distance between the two particles.

### Tech Stack
- **Swift**: Used for the app UI and logic.
- **Metal**: Used for GPU acceleration to optimize the computation of gravitational forces.

The primary goal of this project is to explore CPU computation times for the N-body simulation and how GPU acceleration can significantly improve performance.

---

## Task 1: CPU-based Simulation

The initial implementation is a CPU-based N-body simulation with 100 particles. This simulation is computationally intensive, especially because the force calculation involves an O(n²) operation to check every pair of particles. While this is simple to implement, it can easily use up to 80% of CPU power for this simple simulation.

### Key Points:
- **CPU Usage**: Significant during the simulation.
- **Gravitational Force Calculation**: A nested loop that calculates the force between every pair of particles.
- **Simulation Performance**: While running, the CPU is highly utilized, which could slow down the system.

### Example Graphs:
![Figure 1: CPU usage while running the simulation.](https://github.com/user-attachments/assets/65547bb7-34ca-41a5-9973-faf0af8b18bc)
- **Figure 1**: CPU usage while running the simulation.

![Figure 2: Screenshot of the N-body simulation.](https://github.com/user-attachments/assets/389f86e4-3fb9-474d-ae29-7295cd8d66bc)
- **Figure 2**: Screenshot of the N-body simulation.

---

## Task 2: GPU Acceleration with Metal

In the second task, GPU acceleration is implemented using Metal to offload the computationally expensive tasks to the GPU. Metal allows us to parallelize the computation by assigning each particle to a GPU thread. This allows the simulation to be computed much faster, using far less CPU power.

### Metal Setup:
- **GPU Device Setup**: In this step, a Metal device is selected, and the necessary command buffers and compute pipeline states are created.
- **Shader Implementation**: We use Metal shaders to compute the particle updates in parallel on the GPU.
- **Data Communication**: The Swift app sends the particle data to the GPU, executes the compute shader, and retrieves the results.

The CPU usage drops significantly when using GPU acceleration, and frame computation speeds improve dramatically.

### Example Graph:
![Figure 3: CPU usage after GPU acceleration is implemented.](https://github.com/user-attachments/assets/dd5756f8-fb5f-4757-816d-3eac08cf6be6)
- **Figure 3**: CPU usage after GPU acceleration is implemented.

---

## Results

Using an M2 Pro chip, we conducted benchmarks to compare the performance of the CPU-only model and the GPU-accelerated model. The results are as follows:

### Performance Comparison:

| Model | CPU (ms/frame) | GPU (ms/frame) |
|-------|----------------|----------------|
| n = 250, 60fps | 75.96ms | 1.95ms |
| n = 250, 120fps | 77.64ms | 2.22ms |

### Summary:
- The GPU-accelerated version of the simulation is significantly faster, with average frame times improving by approximately **38.93x** (97.43% faster) compared to the CPU model.
- For higher frame rates (e.g., 120fps), GPU acceleration is still around **35x faster**.

---

## How to Run the Simulation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/emirdur/NBodySim.git
   cd NBodySim

2. **Open the repository with XCode and enjoy!**
