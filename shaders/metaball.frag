#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 texelSize;
    float blurRadius;
    float alphaThreshold;
    float edgeSoftness;
    vec4 liquidColor;
};

layout(binding = 1) uniform sampler2D blurredSource;
layout(binding = 2) uniform sampler2D originalSource;

void main() {
    float blurredAlpha = 0.0;
    float totalWeight = 0.0;

    for (int y = -8; y <= 8; ++y) {
        float offset = float(y);
        float weight = exp(-(offset * offset) / 32.0);
        vec2 uv = qt_TexCoord0 + vec2(0.0, offset * texelSize.y * (blurRadius / 8.0));

        blurredAlpha += texture(blurredSource, uv).a * weight;
        totalWeight += weight;
    }

    blurredAlpha /= totalWeight;

    float antialiasWidth = max(edgeSoftness, fwidth(blurredAlpha) * 1.25);
    float liquidAlpha = smoothstep(alphaThreshold - antialiasWidth,
                                   alphaThreshold + antialiasWidth,
                                   blurredAlpha);
    float originalAlpha = texture(originalSource, qt_TexCoord0).a;
    float alpha = max(originalAlpha, liquidAlpha);

    float finalAlpha = alpha * liquidColor.a;
    fragColor = vec4(liquidColor.rgb * alpha, finalAlpha) * qt_Opacity;
}
