shader_type canvas_item;
render_mode unshaded;

uniform float sample_seed = 1.0;
uniform float mutation_amount : hint_range(0.0, 1.0) = 0.25;
uniform int cell_count : hint_range(0, 40) = 22;
uniform int parasite_count : hint_range(0, 8) = 3;
uniform float movement_speed : hint_range(0.0, 2.0) = 0.5;

uniform vec4 background_color : source_color =
	vec4(0.76, 0.80, 0.65, 1.0);
uniform vec4 healthy_color : source_color =
	vec4(0.60, 0.24, 0.24, 1.0);
uniform vec4 mutated_color : source_color =
	vec4(0.33, 0.18, 0.40, 1.0);
uniform vec4 parasite_color : source_color =
	vec4(0.12, 0.20, 0.13, 1.0);

float hash(float n) {
	return fract(sin(n * 127.1 + sample_seed * 311.7)
		* 43758.5453);
}

// Shortest offset in a repeating field.
vec2 wrapped_offset(vec2 point, vec2 center) {
	return fract(point - center + 0.5) - 0.5;
}

void fragment() {
	vec2 uv = UV;
	float t = TIME * movement_speed;

	vec3 color = background_color.rgb;

	// Slowly changing distortion gives the fluid a subtle flow.
	vec2 fluid_uv = uv + 0.004 * vec2(
		sin(uv.y * 1.0 + t * 0.7),
		cos(uv.x * 19.0 - t * 0.6)
	);

	// CELLS
	for (int i = 0; i < 40; i++) {
		if (i >= cell_count) {
			break;
		}

		float id = float(i) + 1.0;
		float phase = hash(id + 30.0) * TAU;

		vec2 center = vec2(hash(id), hash(id + 71.0));

		center += vec2(
			sin(t * 0.22 + phase),
			cos(t * 0.18 + phase)
		) * 0.035;

		center += vec2(t * 0.005, t * 0.003);

		vec2 p = wrapped_offset(fluid_uv, center);

		float radius = mix(0.025, 0.052, hash(id + 12.0));
		float mutated =
			1.0 - step(mutation_amount, hash(id + 140.0));

		float angle = atan(p.y, p.x);

		// Healthy cells gently wobble.
		// Mutated cells have stronger, irregular lobes.
		float wobble =
			sin(angle * 3.0 + phase + t) * 0.035;

		wobble += mutated * (
			sin(angle * 5.0 + phase - t * 1.3) * 0.13
			+ sin(angle * 7.0 - phase + t * 0.8) * 0.06
		);

		float boundary = radius * (1.0 + wobble);
		float distance_from_center = length(p);
		float edge = distance_from_center - boundary;

		float body = 1.0 - smoothstep(-0.003, 0.003, edge);

		float membrane =
			1.0 - smoothstep(0.001, 0.004, abs(edge));

		vec3 tint = mix(
			healthy_color.rgb,
			mutated_color.rgb,
			mutated
		);

		// Translucent interior.
		color = mix(color, tint, body * 0.25);

		// Darker membrane.
		color = mix(color, tint * 0.55, membrane * 0.65);

		// Pale central depression, resembling a red blood cell.
		float depression = 1.0 - smoothstep(
			radius * 0.22,
			radius * 0.65,
			distance_from_center
		);

		color = mix(
			color,
			background_color.rgb,
			depression * body * 0.35 * (1.0 - mutated)
		);

		// Fictional dark inclusion inside mutated cells.
		vec2 inclusion_offset =
			vec2(sin(phase), cos(phase)) * radius * 0.25;

		float inclusion = 1.0 - smoothstep(
			radius * 0.17,
			radius * 0.30,
			length(p - inclusion_offset)
		);

		color = mix(
			color,
			tint * 0.4,
			inclusion * mutated * body * 0.75
		);
	}

	// PARASITES
	for (int i = 0; i < 8; i++) {
		if (i >= parasite_count) {
			break;
		}

		float id = float(i) + 200.0;
		float phase = hash(id) * TAU;

		vec2 center = vec2(hash(id + 1.0), hash(id + 2.0));
		center += vec2(
			t * 0.018,
			sin(t * 0.8 + phase) * 0.045
		);

		vec2 p = wrapped_offset(fluid_uv, center);

		// Give each parasite a different orientation.
		float rotation = phase + sin(t * 0.4 + phase) * 0.4;
		float c = cos(rotation);
		float s = sin(rotation);
		p = mat2(vec2(c, s), vec2(-s, c)) * p;

		// Wriggling, tapered worm silhouette.
		float half_length = 0.034;
		float along = clamp(p.x / half_length, -1.0, 1.0);

		float curve = sin(
			along * 5.0 - t * 5.0 + phase
		) * 0.006;

		float width = 0.0045 * sqrt(
			max(0.0, 1.0 - along * along)
		);

		float body = 1.0 - smoothstep(
			width,
			width + 0.002,
			abs(p.y - curve)
		);

		body *= 1.0 - smoothstep(
			half_length - 0.002,
			half_length,
			abs(p.x)
		);

		color = mix(color, parasite_color.rgb, body * 0.9);
	}

	// Subtle fixed grain.
	float grain = fract(
		sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453
	);
	color += (grain - 0.5) * 0.025;

	// Circular microscope opening with dark edges.
	float view_distance = length(uv - vec2(0.5));
	float opening = 1.0 - smoothstep(0.46, 0.49, view_distance);
	float vignette = 1.0 - smoothstep(0.15, 0.50, view_distance) * 0.3;

	color *= vignette;
	color = mix(vec3(0.015), color, opening);

	COLOR = vec4(color, 1.0);
}