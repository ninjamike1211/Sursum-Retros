function setupOptions() {

    return new Page("main")
        .add(asBool("AFFINE_MAP", true))
        .add(asBool("AFFINE_WRAP", true))
        .add(asBool("VERTEX_WOBBLE", true))
        .add(asString("VERTEX_INACCURACY", "0.005", "0.010", "0.015", "0.020", "0.025", "0.030", "0.040", "0.050").build("0.015"))
        .add(asInt("DITHER_COLORS", 2, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128, 196, 256).build(128))
        .add(asString("DITHER_AMOUNT", "0.000", "0.001", "0.002", "0.003", "0.004", "0.005", "0.006", "0.008", "0.010", "0.015", "0.020").build("0.005"))
        .add(asInt("COLOR_DEPTH", 2, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128, 196, 256).build(24))
        .add(asString("RESOLUTION_SCALE", "0.05", "0.10", "0.15", "0.20", "0.25", "0.30", "0.35", "0.40", "0.45", "0.50", "0.75", "1.00").build("0.20"))
        .add(asInt("FOG_TYPE", 0, 1, 2).build(1))

        .build();
}
