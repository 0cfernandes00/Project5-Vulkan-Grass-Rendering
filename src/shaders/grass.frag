#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec3 in_pos;
layout(location = 1) in vec3 in_normal;
layout(location = 2) in vec2 in_uv;
layout(location = 3) in float in_height;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color

    vec3 baseColor = vec3(0.2, 0.4, 0.1);
    vec3 tipColor = vec3(0.5, 0.8, 0.3);
    
    vec3 grassColor = mix(baseColor, tipColor, in_height);
    
    // Simple lighting
    vec3 lightPos = vec3(10,10,10);
    vec3 lightDir = normalize(lightPos - in_pos);
    float diffuse = max(dot(in_normal, lightDir), 0.0);
    float ambient = 0.4;
    float lighting = (ambient + diffuse * 0.6);

    float widthVar = 0.9 + 0.1 * abs(in_uv.x * 2.0 - 1.0);
    
    vec3 finalColor = grassColor * lighting * widthVar;
    
    outColor = vec4(finalColor, 1.0);

}
