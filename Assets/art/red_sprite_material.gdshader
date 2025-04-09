shader_type canvas_item;


void fragment() {
	COLOR = vec4(0.545098, 0, 0, texture(TEXTURE, UV).a);
}