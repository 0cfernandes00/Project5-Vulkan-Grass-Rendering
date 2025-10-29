Vulkan Grass Rendering
==================================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 5**

* Caroline Fernandes
  * [LinkedIn](https://www.linkedin.com/in/caroline-fernandes-0-/), [personal website](https://0cfernandes00.wixsite.com/visualfx)
* Tested on: Windows 11, i9-14900HX @ 2.20GHz, Nvidia GeForce RTX 4070

### (Features and Sections)

The goal of this project was to get comfortable with Vulkan and implement [Responsive Real-Time Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf).

## Grass Rendering
Each blade was represented by a bezier curve and three control points.
<img width="390" height="300" alt="image" src="https://github.com/user-attachments/assets/6f92d856-b80e-48d8-bc11-42d679e943c6" />

<img src="img/grass_rendering.gif" width="400"> 

## Simulating Forces
These forces were summed and applied in the compute shader.
### Gravity
### Recovery
### Wind

## Culling
### Orientation Culling
It's important to cull blades with a front vector pointing away from the camera's look vector, because the width will become zero and rendering these pixels will produce rendering artifacts.

<img src="img/orientation_culling.gif" width="400"> 

**Note:** Values have been adjusted to show off the effect

### Frustum Culling
Blades the fall outside of the viewing frustrum will not be visible, and should be optimized out.

![](img/viewFrustrum_culling.gif)

**Note:** Values have been adjusted to show off the effect

### Distance Culling
Blades that are outside a defined range from camera will be optimized out.

![](img/grass_dist_occl.gif)

**Note:** Values have been adjusted to show off the effect
