shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;
uniform float amount : hint_range(0.0, 10.0) = 1.0;

void fragment() {
	vec4 sum = vec4(0.0);
	float total = 0.0;
	for (int x = -4; x <= 4; x++) {
		for (int y = -4; y <= 4; y++) {
			vec2 offset = vec2(float(x), float(y)) * SCREEN_PIXEL_SIZE * amount;
			sum += texture(screen_texture, SCREEN_UV + offset);
			total += 1.0;
		}
	}
	COLOR = sum / total;
}

//shader_type canvas_item;
//
//uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
//uniform float amount : hint_range(0.0, 5.0) = 2;
//
//void vertex() {
	//// Called for every vertex the material is visible on.
//}
//
//void fragment() {
	////vec4 color = textureLod(screen_texture, SCREEN_UV, amount);
	////COLOR = color;
	//vec4 color = textureLod(screen_texture, SCREEN_UV, amount);
	//COLOR = vec4(color.rgb * 0.7, 1.0);
//}
//
////void light() {
////	// Called for every pixel for every light affecting the CanvasItem.
////	// Uncomment to replace the default light processing function with this one.
////}
