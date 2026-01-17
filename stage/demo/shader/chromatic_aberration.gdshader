shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float aberration_distance : hint_range(0.001, 0.05, 0.001);
uniform vec4 extract_color_left : source_color;
uniform vec4 extract_color_right : source_color;

void fragment() {
	vec4 color_left = texture(screen_texture, SCREEN_UV - vec2(aberration_distance, 0.0));
	vec4 color_current = texture(screen_texture, SCREEN_UV);
	vec4 color_right = texture(screen_texture, SCREEN_UV + vec2(aberration_distance, 0.0));
	vec4 extracted_color_left = color_left * extract_color_left * distance(color_left, color_current);
	vec4 extracted_color_right = color_right * extract_color_right * distance(color_right, color_current);
	COLOR = extracted_color_left * 0.33 + color_current * 0.33 + extracted_color_right * 0.33;
}

