const vec3 NoonHorizonColor    = vec3(0.4, 0.5, 1.0);
const vec3 NoonSkyColor        = vec3(0, 0.27, 0.95);
const vec3 SunriseHorizonColor = vec3(0.7, 0.6, 0.6);
const vec3 SunriseSkyColor     = vec3(0.4, 0.35, 0.75);
const vec3 NightHorizonColor   = vec3(0.15);
const vec3 NightSkyColor       = vec3(0.0);

const vec3 lavaFogColor = vec3(2.0, 0.4, 0.1);
const vec3 snowFogColor = vec3(1.0);

const float waterFogDist = 25;
const float lavaFogDist  = 10;
const float snowFogDist  = 15;

float luminance(vec3 v) {
    return dot(v, vec3(0.2126f, 0.7152f, 0.0722f));
}

vec3 getOverworldSkyColor(vec3 viewPos) {
	vec3 viewDir = normalize(viewPos);
	float upDot = max(dot(viewDir, ap.camera.view[1].xyz), 0.0);
	float mixFactor = smoothstep(0.0, 0.7, upDot);

	float worldTimeAdjusted = ((ap.world.time + 785) % 24000) / 24000.0;

	vec3 horizonSkyColor;
	vec3 upperSkyColor;

	if(worldTimeAdjusted < 0.1) {
		horizonSkyColor = mix(SunriseHorizonColor, NoonHorizonColor, worldTimeAdjusted / 0.1);
		upperSkyColor = mix(SunriseSkyColor, NoonSkyColor, worldTimeAdjusted / 0.1);
	}
	else if(worldTimeAdjusted >= 0.1 && worldTimeAdjusted < 0.465) {
		horizonSkyColor = NoonHorizonColor;
		upperSkyColor = NoonSkyColor;
	}
	else if(worldTimeAdjusted >= 0.465 && worldTimeAdjusted < 0.565) {
		horizonSkyColor = mix(NoonHorizonColor, SunriseHorizonColor, (worldTimeAdjusted - 0.465) / 0.1);
		upperSkyColor = mix(NoonSkyColor, SunriseSkyColor, (worldTimeAdjusted - 0.465) / 0.1);
	}
	else if(worldTimeAdjusted >= 0.565 && worldTimeAdjusted < 0.605) {
		horizonSkyColor = mix(SunriseHorizonColor, NightHorizonColor, (worldTimeAdjusted - 0.565) / 0.04);
		upperSkyColor = mix(SunriseSkyColor, NightSkyColor, (worldTimeAdjusted - 0.565) / 0.04);
	}
	else if(worldTimeAdjusted >= 0.605 && worldTimeAdjusted < 0.97) {
		horizonSkyColor = NightHorizonColor;
		upperSkyColor = NightSkyColor;
	}
	else {
		horizonSkyColor = mix(NightHorizonColor, SunriseHorizonColor, (worldTimeAdjusted - 0.97) / 0.03);
		upperSkyColor = mix(NightSkyColor, SunriseSkyColor, (worldTimeAdjusted - 0.97) / 0.03);
	}

	horizonSkyColor = mix(horizonSkyColor, ap.world.fogColor.rgb, ap.world.rainStrength);
	upperSkyColor = mix(upperSkyColor, ap.world.skyColor.rgb, ap.world.rainStrength);

	return mix(horizonSkyColor, upperSkyColor, mixFactor);
}

vec3 getSkyColor(vec3 viewPos) {
    if(ap.camera.fluid == 0) {
        return getOverworldSkyColor(viewPos);
    }
    else if(ap.camera.fluid == 1) {
        return ap.world.fogColor.rgb;
    }
    else if(ap.camera.fluid == 2) {
        return lavaFogColor;
    }
    else if(ap.camera.fluid == 3) {
        return snowFogColor;
    }
}

void applyFog(inout vec3 sceneColor, vec3 viewPos, float fogDist) {
    vec3 fogCol;
    float fogFactor;
    
    if(ap.camera.fluid == 0) {
        fogCol = getOverworldSkyColor(viewPos);
        fogFactor = min(fogDist / ap.camera.far, 1.0);
    }
    else if(ap.camera.fluid == 1) {
        fogCol = ap.world.fogColor.rgb;
        fogFactor = min(fogDist / waterFogDist, 1.0);
    }
    else if(ap.camera.fluid == 2) {
        fogCol = lavaFogColor;
        fogFactor = min(fogDist / lavaFogDist, 1.0);
    }
    else if(ap.camera.fluid == 3) {
        fogCol = snowFogColor;
        fogFactor = min(fogDist / snowFogDist, 1.0);
    }

    sceneColor = mix(sceneColor, fogCol, fogFactor);
}