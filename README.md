Vulkan Grass Rendering
==================================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 5**

* Caroline Fernandes
  * [LinkedIn](https://www.linkedin.com/in/caroline-fernandes-0-/), [personal website](https://0cfernandes00.wixsite.com/visualfx)
* Tested on: Windows 11, i9-14900HX @ 2.20GHz, Nvidia GeForce RTX 4070

### Overview

The goal of this project was to get comfortable with Vulkan and implement [Responsive Real-Time Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf). I am responsible for implementing the grass vertex, grass tessellation control/evaluate, grass fragment, and compute shaders.

In order to build the project, I made updates to CMakeLists.txt and updated the glfw folder to pull in the most recent from this repository https://github.com/glfw/glfw

<img src="img/final_output.gif" width="450"> 

## Grass Rendering
Each blade was represented by a bezier curve and three control points. De Castelajau's algorithm was used to construct the curve, and generate the triangle representation.

<img width="390" height="300" alt="image" src="https://github.com/user-attachments/assets/6f92d856-b80e-48d8-bc11-42d679e943c6" />

<img src="img/grass_rendering.gif" width="450"> 

**Note:** Values have been adjusted for the remaining videos to show off the effect

## Simulating Forces
These forces were summed and applied in the compute shader of the pipeline.

### Gravity
Gravity is implemented as the summation of environmental and "front" facing gravity (which is applied to the front viewing vector of the blade). 

<img width="209" height="72" alt="image" src="https://github.com/user-attachments/assets/81debb17-2adf-4146-a9b5-b5484407c6c0" />

<img src="img/gravity.gif" width="450"> 

### Recovery

Recovery acts as a targeting force to bring the blade back to its starting position. The paper includes collisions, but my implementation was just influenced by the v2's current position, starting position, and a stiffness coefficient.

<img width="336" height="55" alt="image" src="https://github.com/user-attachments/assets/b104b6e4-b528-4110-bbad-4f80c6d13ede" />


### Wind

I simulated wind to be the combination of a wind direction and wind alignment. Blades with a forward vector aligned with the wind direction received more of an impact from the wind. Sin and Cosine waves that change over time were used to produce the waves.

<img width="338" height="281" alt="image" src="https://github.com/user-attachments/assets/23c0f349-bac3-4883-9784-a394f1eb6388" />

<img src="img/wind.gif" width="450"> 

## Culling

### Orientation Culling
Culls the blades with a front vector pointing away from the camera's look vector, because the width will become zero and rendering these pixels will produce rendering artifacts.

<img src="img/orientation_culling.gif" width="450"> 

### View Frustum Culling
Culls the blades that fall outside of the viewing frustum as they will not be visible.

<img src="img/viewFrustrum_culling.gif" width="450"> 

### Distance Culling
Culls the blades that are outside a defined range from the camera.

<img src="img/grass_dist_occl.gif" width="450"> 

## Performance Analysis
I tested using values suggested by the paper, however, the performance results did not match my expectations. Further turning of the parameters could reveal more obvious trends.

Culling Impact

<img src="img/numblades.png" width="450"> 

I tested different scene sizes with all three culling effects applied and compared that without those optimizations. This result was perhaps the most confusing, I had assumed the benefits of culling would outweigh the costs. In smaller scenes especially the opposite was true. In larger scenes the two results were comparable.

Culling Technique Breakdown

<img src="img/cullmethod.png" width="600"> 

Culling by blade orientation seemed to have the largest impact with smaller scenes, whereas with larger scenes the viewing frustum optimization seemed to be the most impactful.
