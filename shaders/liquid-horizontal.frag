#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 texelSize;
    float blurRadius;
};

layout(binding = 1) uniform sampler2D source;

void main() {
    float alpha = 0.0;
    float totalWeight = 0.0;

    for (int x = -8; x <= 8; ++x) {
        float offset = float(x);
        float weight = exp(-(offset * offset) / 32.0);
        vec2 uv = qt_TexCoord0 + vec2(offset * texelSize.x * (blurRadius / 8.0), 0.0);

        alpha += texture(source, uv).a * weight;
        totalWeight += weight;
    }

    alpha /= totalWeight;
    fragColor = vec4(alpha, alpha, alpha, alpha) * qt_Opacity;
}
