shader_type spatial;
render_mode cull_disabled, unshaded;

uniform float speed = 3.0;
uniform vec4 color_base : source_color = vec4(0.25, 0.41, 0.88, 1.0);
uniform float time_scale = 1.0;
varying float v_alpha;

void vertex() {
	float plate_seed = COLOR.r * 100.0;
	float anim = (sin(TIME * speed + plate_seed) * 0.5 + 0.5) / 5.0;
	VERTEX += NORMAL * anim;
	v_alpha = 1.0 - (4.0 * anim);
}

void fragment() {
	ALBEDO = color_base.rgb;
	ALPHA = v_alpha;
}