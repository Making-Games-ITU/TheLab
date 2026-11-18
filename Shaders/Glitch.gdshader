shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float intensity : hint_range(0.0, 1.0) = 0.5;

uniform float red_displacement : hint_range(0.0, 0.1) = 0.02;
uniform float green_displacement : hint_range(0.0, 0.1) = 0.02;
uniform float blue_displacement : hint_range(0.0, 0.1) = 0.02;

uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.3;
uniform float noise_intensity : hint_range(0.0, 1.0) = 0.2;
uniform float slice_intensity : hint_range(0.0, 1.0) = 0.4;
uniform float ghost_intensity : hint_range(0.0, 0.5) = 0.1;
uniform float negative_intensity : hint_range(0.0, 1.0) = 0.0;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    float glitch_time = TIME;

    float slice_y = random(vec2(glitch_time * 10.0, 0.0));
    if (abs(uv.y - slice_y) < 0.02 * slice_intensity) {
        float slice_offset = (random(vec2(glitch_time * 15.0, 0.0)) - 0.5)
            * 0.1 * slice_intensity;
        uv.x += slice_offset;
    }

    float vertical_shift = random(vec2(glitch_time * 8.0, 0.0)) * 0.05 * intensity;
    uv.y += vertical_shift;

    float wave = sin(uv.y * 100.0 + glitch_time * 5.0) * 0.01 * intensity;
    uv.x += wave;

    vec4 final_color = texture(screen_texture, uv);
    final_color.r = texture(screen_texture, uv + vec2(red_displacement, 0.0)).r;
    final_color.g = texture(screen_texture, uv + vec2(-green_displacement, 0.0)).g;
    final_color.b = texture(screen_texture, uv + vec2(blue_displacement, 0.0)).b;

    float scanline = sin(uv.y * 300.0 + glitch_time * 2.0) * 0.5 + 0.5;
    final_color.rgb *= 1.0 - scanline * scanline_intensity * intensity;

    float static_noise = random(uv + vec2(glitch_time)) * noise_intensity;
    final_color.rgb += static_noise;

    if (ghost_intensity > 0.0) {
        vec3 ghost_color = texture(screen_texture, uv + vec2(0.01, 0.01)).rgb
            * ghost_intensity;
        final_color.rgb = mix(final_color.rgb, ghost_color, ghost_intensity * 0.5);
    }

    if (negative_intensity > 0.0) {
        final_color.rgb = mix(final_color.rgb, 1.0 - final_color.rgb, negative_intensity);
    }

    final_color.rgb += 0.2 * intensity;
    COLOR = final_color;
}