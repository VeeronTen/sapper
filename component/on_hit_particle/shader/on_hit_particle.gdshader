shader_type canvas_item;

varying float lifetime;

void vertex() {
	lifetime = INSTANCE_CUSTOM.y;
}

void fragment() {
	vec4 screenColor = vec4(0.3 + lifetime, 0.0, 0.0, 1.0 - lifetime);
	screenColor = screenColor * texture(TEXTURE, UV).r;
	COLOR = screenColor;
}
