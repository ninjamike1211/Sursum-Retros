#version 450 core

layout(location = 0) out vec4 albedo;

in vec2 uv;
in vec2 light;
in vec4 color;

void iris_emitFragment() {
    vec2 mUV = uv, mLight = light;
    vec4 mColor = color;

    iris_modifyBase(mUV, mColor, mLight);

    vec4 col = iris_sampleBaseTex(mUV) * mColor * iris_sampleLightmap(mLight);

    albedo = col;
}