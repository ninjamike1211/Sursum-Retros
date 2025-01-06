#version 450 core

out vec3 viewPos;

void iris_emitVertex(inout VertexData data) {
    viewPos = (iris_modelViewMatrix * data.modelPos).xyz;

    #if defined VERTEX_WOBBLE && defined VERTEX_ROUND
        vec4 clipPos = iris_projectionMatrix * vec4(viewPos, 1.0);
        vec2 ndcPos = clipPos.xy / clipPos.w;
        ndcPos = floor(ndcPos / VERTEX_INACCURACY) * VERTEX_INACCURACY;
        data.clipPos = vec4(ndcPos*clipPos.w, clipPos.zw);
    #else
        #ifdef RENDER_TEXT
            // viewPos += 0.1 * data.normal;
            // viewPos.z += 0.1;
        #endif
        data.clipPos = iris_projectionMatrix * vec4(viewPos, 1.0);
    #endif
}


out vec2 light;
out vec4 color;

#if defined AFFINE_MAP && defined AFFINE_UV
    noperspective out vec2 uv;
    out vec2 uvMinBounds;
    out vec2 uvMaxBounds;
#else
    out vec2 uv;
#endif

void iris_sendParameters(in VertexData data) {
    vec3 colRGB = data.color.rgb * data.ao;
    color = vec4(mix(data.overlayColor.rgb, colRGB, data.overlayColor.a), data.color.a);

    uv = data.uv;
    // uv = data.uv * data.clipPos.w;
    light = data.light;

    #if defined AFFINE_MAP && defined AFFINE_UV
        uvMinBounds = iris_getTexture(data.textureId).minCoord;
        uvMaxBounds = iris_getTexture(data.textureId).maxCoord;
    #endif
}