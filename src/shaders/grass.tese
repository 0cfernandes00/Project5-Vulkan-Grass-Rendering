#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs

layout(location=0) in vec4 in_v1[];
layout(location=1) in vec4 in_v2[];
layout(location=2) in vec4 in_up[];

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

    // evaluate bezier curve
    vec3 curve = bezierCurve(v0, v1, v2, v);

    // get bezier tangent (derivative)
    vec3 tangent = normalize(bezierTangent(v0, v1, v2, v));

    // get right vector
    vec3 rightAxis = normalize(cross(up, tangent));
    if (length(rightAxis) < 0.001) {
        rightAxis = vec3(1, 0, 0);
    }

    // width taper
    float widthTaper = width * (1.0 - v);

    vec3 finalPos = curve + rightAxis * widthTaper * (u - 0.5);

    // calculate normal
    vec3 normal = normalize(cross(tangent,rightAxis));
    out_normal = normal;
    out_height = v;
    
    // uv texture
    out_uv = vec2(u,v);
    
    // transform to clip space
    gl_Position = camera.proj * camera.view * vec4(finalPos, 1.0);
    
}
