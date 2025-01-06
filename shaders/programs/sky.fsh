#version 450 core

#include "/lib/fog.glsl"

layout(location = 0) out vec4 albedo;

in vec3 viewPos;

void iris_emitFragment() {
    vec3 fogCol = getSkyColor(viewPos);
    albedo = vec4(fogCol, 1.0);
}