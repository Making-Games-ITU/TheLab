
shader_type canvas_item;

// BACKGROUND
uniform vec4 background_color : source_color = vec4(0.65, 0.72, 0.60, 1.0);
uniform float grain_strength : hint_range(0.0, 0.3) = 0.08;
uniform float vignette_smoothness : hint_range(0.0, 2.0, 0.1) = 0.5;

// CELLS
uniform vec4 cell_color : source_color = vec4(0.65, 0.35, 0.42, 1.0);
uniform vec4 nucleus_color : source_color = vec4(0.3, 0.15, 0.25, 1.0);

uniform float cell_size : hint_range(0.01, 0.15) = 0.06;
uniform float movement_speed : hint_range(0.0, 3.0) = 0.5;
uniform int cell_amount : hint_range(0, 100) = 20;

// PARASITES
uniform vec4 parasite_color : source_color = vec4(0.20, 0.25, 0.15, 1.0);

uniform int parasite_amount : hint_range(0, 30) = 8;
uniform float parasite_length : hint_range(0.01, 0.2) = 0.09;
uniform float parasite_thickness : hint_range(0.001, 0.02) = 0.003;
uniform float parasite_speed : hint_range(0.0, 3.0) = 0.4;
uniform float parasite_wiggle : hint_range(0.0, 1.0) = 0.5;

//MUTATION

uniform float mutation_percentage : hint_range(0.0, 100.0, 1.0) = 20.0;
uniform vec4 mutated_color : source_color = vec4(0.35, 0.12, 0.22, 1.0);
uniform float mutation_distortion : hint_range(0.0, 1.0) = 0.4;


uniform float aspect_ratio = 1.77778;


// RANDOM
float random(vec2 pos) {
    return fract(
        sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453
    );
}


// CELL SHAPE

float cell_shape(
    vec2 uv,
    vec2 position,
    float radius,
    float seed,
    float mutation
) {
    vec2 offset = uv - position;

    float angle = atan(offset.y, offset.x);
    float d = length(offset);

    float distortion =
        sin(angle * 2.0 + seed * 1.3) * 0.10 +
        sin(angle * 5.0 + seed * 2.1) * 0.05 +
        sin(angle * 9.0 + seed * 3.7) * 0.025;

    float extra_distortion =
        sin(angle * 3.0 + seed * 4.2) * 0.25 +
        sin(angle * 7.0 + seed * 2.8) * 0.15;

    distortion += extra_distortion * mutation * mutation_distortion;

    float new_radius = radius * (1.0 + distortion);

    return 1.0 - smoothstep(
        new_radius * 0.75,
        new_radius,
        d
    );
}



// WORM SHAPE
float parasite_shape(
    vec2 uv,
    vec2 position,
    float length_radius,
    float thickness,
    float rotation,
    float seed
) {
    vec2 offset = uv - position;

    // Rotate the worm.
    float c = cos(rotation);
    float s = sin(rotation);

    vec2 local = vec2(
        offset.x * c + offset.y * s,
        -offset.x * s + offset.y * c
    );

    float along = local.x / length_radius;

    float wave = sin(
        along * 7.0 - TIME * 5.0 + seed
    );

    local.y -= wave * length_radius * 0.12 * parasite_wiggle;

    float taper = sqrt(
        max(0.0, 1.0 - along * along)
    );

    float local_thickness = thickness * taper;

    float body = 1.0 - smoothstep(
        local_thickness * 0.5,
        local_thickness + 0.0005,
        abs(local.y)
    );

    float ends = 1.0 - smoothstep(
        0.95,
        1.0,
        abs(along)
    );

    return body * ends;
}


void fragment() {
    vec2 uv = UV;
    vec2 sample_uv = vec2(uv.x * aspect_ratio, uv.y);

    vec3 color = background_color.rgb;

    float grain = random(
        floor(uv * 500.0) + floor(TIME * 12.0)
    );

    color += (grain - 0.5) * 2.0 * grain_strength;


    // PARASITES

    for (int i = 0; i < parasite_amount; i++) {

        vec2 id = vec2(float(i), 200.0);

        float rx = random(id + vec2(11.0, 3.0));
        float ry = random(id + vec2(27.0, 14.0));
        float rs = random(id + vec2(53.0, 29.0));
        float ra = random(id + vec2(81.0, 47.0));

        float rotation = ra * 6.283185;

        float speed = parasite_speed * (0.6 + rs * 0.8);

        vec2 direction = vec2(
            cos(rotation),
            sin(rotation)
        );

        vec2 position = vec2(rx, ry);

        position += direction * TIME * speed * 0.03;

        position = fract(position);

        position.x *= aspect_ratio;

        rotation += sin(
            TIME * speed + rs * 10.0
        ) * 0.3;

        float worm_length = parasite_length * (0.7 + rs * 0.6);
        float worm_thickness = parasite_thickness * (0.7 + rs * 0.6);

        float parasite = parasite_shape(
            sample_uv,
            position,
            worm_length,
            worm_thickness,
            rotation,
            rs * 30.0
        );

        color = mix(
            color,
            parasite_color.rgb,
            parasite * 0.9
        );
    }

    // CELLS

    for (int x = 0; x < cell_amount; x++) {
        for (int y = 0; y < cell_amount; y++) {

            vec2 id = vec2(float(x), float(y));
			float mutation_random = random(id + vec2(143.0, 87.0));
			float mutation = step(
			    mutation_random,
			    mutation_percentage / 100.0
			);

            float rx = random(id);
            float ry = random(id + vec2(25.0, 10.0));
            float rs = random(id + vec2(52.0, 17.0));

            vec2 position = vec2(
                (float(x) + 0.25 + rx * 0.5) / float(cell_amount),
                (float(y) + 0.2 + ry * 0.5) / float(cell_amount)
            );

            position.x += sin(
                TIME * movement_speed + rx * 10.0
            ) * 0.06;

            position.y += cos(
                TIME * movement_speed + ry * 10.0
            ) * 0.06;

            position.x *= aspect_ratio;

            float radius = cell_size * (0.7 + rs * 0.6);

		    float cell = cell_shape(
		    sample_uv,
		    position,
		    radius,
		    rs * 37.0,
		    mutation
			);

			vec3 final_cell_color = mix(
			    cell_color.rgb,
			    mutated_color.rgb,
			    mutation
			);

			color = mix(
			    color,
			    final_cell_color,
			    cell * 0.65
			);

            float nrx = random(id + vec2(82.0, 17.0));
            float nry = random(id + vec2(43.0, 91.0));

            vec2 nucleus_position = position + vec2(
                (nrx - 0.5) * radius * 0.4,
                (nry - 0.5) * radius * 0.4
            );

            float nucleus_radius = radius * (0.2 + rs * 0.2);

            float nucleus = cell_shape(
                sample_uv,
                nucleus_position,
                nucleus_radius,
                rs * 73.0,
				mutation
            );

            color = mix(
                color,
                nucleus_color.rgb,
                nucleus * 0.85
            );
        }
    }


    // MICROSCOPE VIGNETTE
    float dist = distance(
        sample_uv,
        vec2(aspect_ratio * 0.5, 0.5)
    );

    float vignette = 1.0 - smoothstep(
        0.15,
        0.15 + max(vignette_smoothness, 0.001),
        dist
    );

    color *= mix(0.35, 1.0, vignette);

    COLOR = vec4(color, 1.0);
}
