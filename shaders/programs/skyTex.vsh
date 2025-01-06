#version 450 core

void iris_emitVertex(inout VertexData data) {
    data.clipPos = iris_projectionMatrix * iris_modelViewMatrix * data.modelPos;
}


out vec2 uv;
out vec2 light;
out vec4 color;

void iris_sendParameters(in VertexData data) {
    vec3 colRGB = data.color.rgb * data.ao;
    color = vec4(mix(data.overlayColor.rgb, colRGB, data.overlayColor.a), data.color.a);

    uv = data.uv;
    light = data.light;
}