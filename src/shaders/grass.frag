#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec3 in_normal;
layout(location = 1) in vec2 in_uv;
layout(location = 2) in float in_height;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color

    vec3 baseColor = vec3(0.2, 0.4, 0.1);
    vec3 tipColor = vec3(0.5, 0.8, 0.3);
    
    vec3 grassColor = mix(baseColor, tipColor, in_height);
    
    // Simple lighting
    vec3 lightDir = normalize(vec3(0.5, 1.0, 0.3));
    float diffuse = max(dot(in_normal, lightDir), 0.0);
    float ambient = 0.4;
    
    vec3 finalColor = grassColor * (ambient + diffuse * 0.6);
    
    outColor = vec4(finalColor, 1.0);

}
