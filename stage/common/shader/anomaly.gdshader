shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float anomalyPower : hint_range(0.0, 1.0, 0.1);
uniform float anomalySpeed : hint_range(0.0, 3.0, 0.1);

void fragment() {
	float anomalyFinalPower = (texture(TEXTURE, UV) * sin(TIME * anomalySpeed)).a * anomalyPower;
	vec4 screenColor = texture(screen_texture, SCREEN_UV + anomalyFinalPower);	
	COLOR = screenColor;
}

