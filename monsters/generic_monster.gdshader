shader_type canvas_item;

uniform float flash = 0.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, vec3(1.0), flash * (0.5 * sin(TIME * TAU) + 0.5));
	COLOR = color;
}
