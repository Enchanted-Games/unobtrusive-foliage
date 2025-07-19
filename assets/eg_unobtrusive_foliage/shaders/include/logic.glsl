#define FALLOFF_RANGE 5.0
#define FALLOFF_START 2.0

#define DITHER_PIXEL_SIZE 1.0
#define DITHER_NOISE_SIZE 120.0
#define DITHER_NOISE_ORIGINAL_BIAS 40.0
#define DITHER_NOISE_ANIMATION_SPEED 1200.0

const mat4 dither_matrix = mat4(
    // https://discourse.urho3d.io/t/screen-door-transparency/5054/2
    1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0,  11.0 / 17.0,
    13.0 / 17.0, 5.0 / 17.0,  15.0 / 17.0, 7.0 / 17.0,
    4.0 / 17.0,  12.0 / 17.0, 2.0 / 17.0,  10.0 / 17.0,
    16.0 / 17.0, 8.0 / 17.0,  14.0 / 17.0, 6.0 / 17.0
);

void applyDitherMatrix(float dist, vec2 fragCoord) {
    // some devices may have performance issues if a discard statement is present
    // in the solid pipeline (even if its never used), so its wrapped in a
    // define just to be safe
    #ifdef EG_USE_DISCARD
    int x = int(fragCoord.x);
    int y = int(fragCoord.y);
    if (dist < dither_matrix[x % 4][y % 4])
        discard;
    #endif
}

void applyDistanceDither(sampler2D tex, vec2 texCoord, vec3 vertexPos, vec2 screenCoord) {
    int alpha = int(floor(texture(tex, texCoord).a * 255.0));
    if(alpha == 249) {
        float fragDist = length(vertexPos);
        applyDitherMatrix((fragDist * float(FALLOFF_RANGE)) - float(FALLOFF_START), screenCoord.xy / float(DITHER_PIXEL_SIZE));
    }
}