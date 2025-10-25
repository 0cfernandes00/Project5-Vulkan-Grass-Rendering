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

layout(location = 0) out vec3 out_normal;
layout(location = 1) out vec2 out_uv;
layout(location = 2) out float out_height;

out gl_PerVertex {
    vec4 gl_Position;
};

/*
The generated vertices will be passed to the tessellation evaluation shader,
where you will place the vertices in world space, respecting the width, height,
and orientation information of each blade. Once you have determined the world space position of each vector, 
pmake sure to set the output gl_Position in clip space!
*/

vec3 bezierCurve(vec3 p0, vec3 p1, vec3 p2, float t) {
    float s = 1.0 - t;
    //return p0 * interp * interp + 2 * p1 * interp + p2 * interp;
    return s * s * p0 + 2.0 * s * t * p1 + t * t * p2;
}

vec3 bezierTangent(vec3 p0, vec3 p1, vec3 p2, float t) {
    return 2.0 * (1.0 - t) * (p1 - p0) + 2.0 * t * (p2 - p1);
}

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
    float h = mix(gl_in[0].gl_Position.y, gl_in[2].gl_Position.y, v);
    float w = mix(gl_in[0].gl_Position.x, gl_in[1].gl_Position.x, u);

    vec3 v0 = in_v0[0].xyz;
    vec3 v1 = in_v1[0].xyz;
    vec3 v2 = in_v2[0].xyz;
    vec3 up = in_up[0].xyz;

    float orientation = in_v0[0].w;
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
    
    // uv texture for texturing
    out_uv = vec2(u,v);

    // transform to clip space
    gl_Position = camera.proj * camera.view * vec4(finalPos, 1.0);

}
