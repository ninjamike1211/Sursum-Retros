#version 460 core

uniform sampler2D albedoTex;
uniform sampler2D textTex;

in vec2 uv;
out vec4 fragColor;

vec3 GetDither(vec2 pos, vec3 c, float intensity) {
	int DITHER_THRESHOLDS[16] = int[]( -4, 0, -3, 1, 2, -2, 3, -1, -3, 1, -4, 0, 3, -1, 2, -2 );
	int index = (int(pos.x) & 3) * 4 + (int(pos.y) & 3);

	c.xyz = clamp(c.xyz * (DITHER_COLORS-1) + DITHER_THRESHOLDS[index] * (intensity * 100), vec3(0), vec3(DITHER_COLORS-1));

	c /= DITHER_COLORS;
	return c;
}

void main() {
	vec2 dsRes = ap.game.screenSize * RESOLUTION_SCALE;
	vec2 uvFloor = floor(uv * dsRes) / dsRes;

    vec3 sceneColor = texture(albedoTex, uvFloor).rgb;

    vec4 textColor = texture(textTex, uv);
    sceneColor = mix(sceneColor, textColor.rgb, textColor.a);
	sceneColor = GetDither(uvFloor * dsRes + 0.1, sceneColor, DITHER_AMOUNT);
	sceneColor = clamp(floor(sceneColor * COLOR_DEPTH) / COLOR_DEPTH, 0.0, 1.0);

	fragColor = vec4(sceneColor, 1.0);
}
