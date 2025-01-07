
function setupBlockIds() {
    const billboardIds = [
        "minecraft:short_grass",
        "minecraft:tall_grass",
        "minecraft:fern",
        "minecraft:large_fern",
        "minecraft:dead_bush",
        "minecraft:nether_sprouts",
        "minecraft:warped_roots",
        "minecraft:crimson_roots",
        "minecraft:hanging_roots",
        "minecraft:pale_hanging_moss",
        "minecraft:brown_mushroom",
        "minecraft:red_mushroom",
        "minecraft:warped_fungus",
        "minecraft:crimson_fungus",
        "minecraft:blue_orchid",
        "minecraft:allium",
        "minecraft:azure_bluet",
        "minecraft:red_tulip",
        "minecraft:orange_tulip",
        "minecraft:pink_tulip",
        "minecraft:white_tulip",
        "minecraft:poppy",
        "minecraft:oxeye_daisy",
        "minecraft:dandelion",
        "minecraft:lily_of_the_valley",
        "minecraft:cornflower",
        "minecraft:wither_rose",
        "minecraft:closed_eyeblossom",
        "minecraft:open_eyeblossom",
        "minecraft:torchflower",
        "minecraft:torchflower_crop",
        "minecraft:lilac",
        "minecraft:rose_bush",
        "minecraft:peony",
        "minecraft:sweet_berry_bush",
        "minecraft:sugar_cane",
        "minecraft:kelp",
        "minecraft:kelp_plant",
        "minecraft:cave_vines",
        "minecraft:cave_vines_plant",
        "minecraft:twisting_vines",
        "minecraft:twisting_vines_plant",
        "minecraft:weeping_vines",
        "minecraft:weeping_vines_plant",
        "minecraft:oak_sapling",
        "minecraft:birch_sapling",
        "minecraft:spruce_sapling",
        "minecraft:jungle_sapling",
        "minecraft:acacia_sapling",
        "minecraft:dark_oak_sapling",
        "minecraft:pale_oak_sapling",
        "minecraft:cherry_sapling",
        "minecraft:bamboo_sapling",
        "minecraft:melon_stem",
        "minecraft:pumpkin_stem",
        "minecraft:brain_coral",
        "minecraft:bubble_coral",
        "minecraft:fire_coral",
        "minecraft:horn_coral",
        "minecraft:tube_coral",
        "minecraft:dead_brain_coral",
        "minecraft:dead_bubble_coral",
        "minecraft:dead_fire_coral",
        "minecraft:dead_horn_coral",
        "minecraft:dead_tube_coral",
        "minecraft:pointed_dripstone",
        "minecraft:cobweb"
    ];

    for(const id of billboardIds) {
        setLightColor(id, 255, 0, 0, 0);
    }
}

/**
 * {@link setupShader} is your only opportunity to register textures, shaders, and uniforms. It is called once when the shader is loaded, or the screen is resized.
 */
function setupShader() {
    const Settings = {
        Affine_Map : getBoolSetting("AFFINE_MAP"),
        Affine_Wrap : getBoolSetting("AFFINE_WRAP"),
        Vertex_Wobble : getBoolSetting("VERTEX_WOBBLE"),
        Vertex_Inaccuracy : getStringSetting("VERTEX_INACCURACY"),
        Dither_Colors : getIntSetting("DITHER_COLORS"),
        Dither_Amount : getStringSetting("DITHER_AMOUNT"),
        Color_Depth : getIntSetting("COLOR_DEPTH"),
        Resolution_Scale : getStringSetting("RESOLUTION_SCALE"),
        Fog_Type : getIntSetting("FOG_TYPE"),
        Billboarding: getBoolSetting("BILLBOARDING"),
    };

    if(Settings.Affine_Map) defineGlobally("AFFINE_MAP", "1");
    if(Settings.Affine_Wrap) defineGlobally("AFFINE_WRAP", "1");
    if(Settings.Vertex_Wobble) defineGlobally("VERTEX_WOBBLE", "1");
    defineGlobally("VERTEX_INACCURACY", Settings.Vertex_Inaccuracy);
    defineGlobally("DITHER_COLORS", Settings.Dither_Colors);
    defineGlobally("DITHER_AMOUNT", Settings.Dither_Amount);
    defineGlobally("COLOR_DEPTH", Settings.Color_Depth);
    defineGlobally("RESOLUTION_SCALE", Settings.Resolution_Scale);
    defineGlobally("FOG_TYPE", Settings.Fog_Type);
    if(Settings.Billboarding) {
        defineGlobally("BILLBOARDING", "1");
        // setLightColor("minecraft:dead_bush", 255, 0, 0, 0);
        // setLightColor("minecraft:short_grass", 255, 0, 0, 0);
        // setLightColor("minecraft:brown_mushroom", 255, 0, 0, 0);
        setupBlockIds();
    }

    // World settings. For this demo, we will be using Vanilla-like settings.
    worldSettings.ambientOcclusionLevel = 1.0;
    worldSettings.disableShade = false;
    worldSettings.renderEntityShadow = true;
    worldSettings.renderSun = true;  

    
    // This is an example of registering a basic texture.
    let albedoTex = new Texture("albedoTex")
    .format(Format.RGBA8)
    .clear(true)
    .build();

    let textTex = new Texture("textTex")
    .format(Format.RGBA8)
    .clear(true).clearColor(0,0,0,0)
    .build();


    let skyS = new ObjectShader("sky", Usage.SKYBOX)
    .vertex("programs/sky.vsh")
    .fragment("programs/sky.fsh").target(0, albedoTex).build();
    registerShader(skyS);

    let skyTexS = new ObjectShader("skyTex", Usage.SKY_TEXTURES)
    .vertex("programs/skyTex.vsh")
    .fragment("programs/skyTex.fsh").target(0, albedoTex).build();
    registerShader(skyTexS);

    let basicS = new ObjectShader("basic", Usage.BASIC)
    .vertex("programs/object.vsh")
    .fragment("programs/object.fsh").target(0, albedoTex)
    .define("VERTEX_ROUND", "1").build();
    registerShader(basicS);
    
    let terrainS = new ObjectShader("terrain", Usage.TERRAIN_SOLID)
    .vertex("programs/object.vsh")
    .fragment("programs/object.fsh").target(0, albedoTex)
    .define("VERTEX_ROUND", "1")
    .define("AFFINE_UV", "1").build();
    registerShader(terrainS);

    let textS = new ObjectShader("text", Usage.TEXT)
    .vertex("programs/object.vsh")
    .fragment("programs/object.fsh").target(0, textTex)
    .define("RENDER_TEXT", "1").build();
    registerShader(textS);

    let handS = new ObjectShader("hand", Usage.HAND)
    .vertex("programs/object.vsh")
    .fragment("programs/object.fsh").target(0, albedoTex)
    .define("VERTEX_ROUND", "1").build();
    registerShader(handS);

    // Uniforms are registered into a buffer object. You do not specify uniforms with the `uniform` declaration in-shader; rather they are specified here.
    registerUniforms("shadowLightPosition",
                     "screenSize",
                     "playerModelView",
                     "playerModelViewInverse",
                     "nearPlane",
                     "farPlane",
                     "worldTime",
                     "fogColor",
                     "skyColor",
                     "rainStrength",
                     "isEyeInWater",
                     "renderDistance");
    finalizeUniforms();


    // The combination pass is required, and is most similar to the "final" pass in Optifine. It has one output; the main color. No textures will be considered outside of what you use in combination.
    setCombinationPass(new CombinationPass("programs/combination.fsh").build())
}