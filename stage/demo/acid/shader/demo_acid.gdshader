shader_type canvas_item;

uniform sampler2D waterNoise : repeat_enable;
uniform sampler2D waterColor : source_color;
uniform float speed : hint_range(0.0, 1.0, 0.1);

void fragment() {
	float waterPixel = texture(waterNoise, UV + vec2(speed) * TIME).r;
	float waterPixel2 = texture(waterNoise, UV - vec2(speed, 0) * TIME).r;
	vec4 pixelColor = texture(waterColor, vec2(waterPixel + waterPixel2));
	COLOR = pixelColor;
}
