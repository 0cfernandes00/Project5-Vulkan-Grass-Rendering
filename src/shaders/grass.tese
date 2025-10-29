#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs

layout(location=0) in vec4 in_v0[];
layout(location=1) in vec4 in_v1[];
layout(location=2) in vec4 in_v2[];
layout(location=3) in vec4 in_up[];

layout(location = 0) out vec3 out_pos;
layout(location = 1) out vec3 out_normal;
layout(location = 2) out vec2 out_uv;
layout(location = 3) out float out_height;

vec3 bezierCurve(vec3 p0, vec3 p1, vec3 p2, float t) {
    // a = (1-t)
    // b = t
    // A^2 * p0 + 2*a*b*p1 + t^2 * p2;
    float a = (1-t);
    return a*a*p0 + 2*a*t*p1 + t*t*p2;
}

vec3 bezierTangent(vec3 p0, vec3 p1, vec3 p2, float t) {
    // 2ap0 + abp1 + 2bp2
    float a = (1-t);
    return 2.0 * a * (p1 - p0) + 2.0 * t * (p2 - p1);
}

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade

    vec3 v0 = gl_in[0].gl_Position.xyz;
    vec3 v1 = in_v1[0].xyz;
    vec3 v2 = in_v2[0].xyz;
    vec3 up = in_up[0].xyz;

    float orientation = gl_in[0].gl_Position.w;
    float height = in_v1[0].w;
    float width = in_v2[0].w;
    float stiffness = in_up[0].w;

    // de casteljau algorithm
    vec3 orientationDir = vec3(cos(orientation), 0, sin(orientation));
    const vec3 a = v0 + v * (v1 - v0);
    const vec3 b = v1 + v * (v2 - v1);

    // second level
    const vec3 c = a + v * (b - a);
    const vec3 d0 = c - width * orientationDir;
    const vec3 d1 = c + width * orientationDir;
    const vec3 t0 = normalize(b - a);
    out_normal = normalize(cross(t0, orientationDir));

    // position
    const float t = u + 0.5f * v - u * v; 
    const vec3 pos = mix(d0, d1, t);

    gl_Position = camera.proj * camera.view * vec4(pos, 1.f);
    out_pos = gl_Position.xyz;
    out_uv = vec2(u,v);
    out_height = pos.y / height;
    
}
