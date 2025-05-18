function setupOptions() {

    return new Page("main")
        .add(asBool("AFFINE_MAP", true, true))
        .add(asBool("AFFINE_WRAP", true, true))
        .add(asBool("VERTEX_WOBBLE", true, true))
        .add(asFloat("VERTEX_INACCURACY", 0.005, 0.010, 0.015, 0.020, 0.025, 0.030, 0.040, 0.050).needsReload(true).build(0.015))
        .add(asInt("DITHER_COLORS", 2, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128, 196, 256).needsReload(true).build(128))
        .add(asFloat("DITHER_AMOUNT", 0.000, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.008, 0.010, 0.015, 0.020).needsReload(true).build(0.005))
        .add(asInt("COLOR_DEPTH", 2, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128, 196, 256).needsReload(true).build(24))
        .add(asFloat("RESOLUTION_SCALE", 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.75, 1.00).needsReload(true).build(0.20))
        .add(asInt("FOG_TYPE", 0, 1, 2).needsReload(true).build(1))
        .add(asBool("BILLBOARDING", true, true))

        .build();
}
export {
    setupOptions
};