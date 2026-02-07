shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float intensity : hint_range(0.0, 1.0) = 0.0;
uniform float scale : hint_range(1.0, 2.0) = 1.0;

void vertex() {
    VERTEX *= scale;
}

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    vec3 mixed_color = mix(texture_color.rgb, color.rgb, intensity);
    COLOR = vec4(mixed_color, texture_color.a);
}