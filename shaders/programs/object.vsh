#version 450 core

out vec3 viewPos;

void iris_emitVertex(inout VertexData data) {
    vec4 modelPos = data.modelPos;

    #ifdef BILLBOARDING
    if(iris_getLightColor(data.blockId) == vec4(1.0, 0.0, 0.0, 0.0)) {
        if(data.normal.x < 0.0) {
            data.clipPos = vec4(-10, -10, -10, 1);
            return;
        }

        vec2 uvMinBounds = iris_getTexture(data.textureId).minCoord;
        
        // vec2 facePos = vec2((texcoord.x - mc_midTexCoord.x) * sign(at_tangent.w) * atlasSize.x / 16.0, 0.0);
        // vec2 centerPos = vertexPos.xz - 1.8 * facePos.x * normalize(at_tangent).xz * sign(at_tangent.w);
        vec2 centerPos = modelPos.xz + (data.midBlock.xz / 64.0);
        vec2 facePos = vec2(0.8*sign(data.normal.z) * length(data.midBlock.xz) / 64.0 * sign(data.uv.x - uvMinBounds.x - 0.0001), 0.0);

        vec2 viewVec = normalize(ap.camera.viewInv[2].xz);
        // vec2 viewVec = -normalize(modelPos.xz);
        mat2 rotationMatrix = mat2(vec2(viewVec.y, -viewVec.x), vec2(viewVec.x, viewVec.y));
        modelPos.xz = (rotationMatrix * facePos) + centerPos;
    }
    #endif

    viewPos = (iris_modelViewMatrix * modelPos).xyz;

    #if defined VERTEX_WOBBLE && defined VERTEX_ROUND
        vec4 clipPos = iris_projectionMatrix * vec4(viewPos, 1.0);
        vec2 ndcPos = clipPos.xy / clipPos.w;
        ndcPos = floor(ndcPos / VERTEX_INACCURACY) * VERTEX_INACCURACY;
        data.clipPos = vec4(ndcPos*clipPos.w, clipPos.zw);
    #else
        vec4 clipPos = iris_projectionMatrix * vec4(viewPos, 1.0);
        #ifdef RENDER_TEXT
            clipPos.z -= 0.005;
        #endif

        data.clipPos = clipPos;
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