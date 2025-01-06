#version 450 core

out vec3 viewPos;

void iris_emitVertex(inout VertexData data) {
    viewPos = (iris_modelViewMatrix * data.modelPos).xyz;
    data.clipPos = iris_projectionMatrix * vec4(viewPos, 1.0);
}

void iris_sendParameters(in VertexData data) {

}