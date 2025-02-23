shader_type canvas_item;
uniform vec4 colorShade: source_color = vec4(1.0);
void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, colorShade.rgb, 0.4);
	COLOR = color;
}

