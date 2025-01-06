#version 450 core

#include "/lib/fog.glsl"

layout(location = 0) out vec4 albedo;

in vec2 light;
in vec4 color;
in vec3 viewPos;

#if defined AFFINE_MAP && defined AFFINE_UV
    noperspective in vec2 uv;
    in vec2 uvMinBounds;
    in vec2 uvMaxBounds;
#else
    in vec2 uv;
#endif

float linearizeDepthFast(float depth) {
	return (nearPlane * farPlane) / (depth * (nearPlane - farPlane) + farPlane);
}

void iris_emitFragment() {

	#if defined AFFINE_MAP && defined AFFINE_UV
		#ifdef AFFINE_WRAP
			vec2 mUV = mod(uv - uvMinBounds, uvMaxBounds - uvMinBounds) + uvMinBounds;
		#else
			vec2 mUV = clamp(uv, uvMinBounds, uvMaxBounds-0.000001);
		#endif
	#else
		vec2 mUV = uv;
	#endif

	vec2 mLight = light;
    vec4 mColor = color;

    iris_modifyBase(mUV, mColor, mLight);

    vec4 col = iris_sampleBaseTexLod(mUV, 0) * mColor * iris_sampleLightmap(mLight);

    if (iris_discardFragment(col)) discard;

	#if FOG_TYPE == 0
		float fogDist = linearizeDepthFast(gl_FragCoord.z);
	#elif FOG_TYPE == 1
		float fogDist = length((playerModelViewInverse * vec4(viewPos, 1.0)).xz);
	#elif FOG_TYPE == 2
		float fogDist = length(viewPos);
	#endif

	applyFog(col.rgb, viewPos, fogDist);

    albedo = col;
}