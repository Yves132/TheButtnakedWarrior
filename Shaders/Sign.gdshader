shader_type canvas_item;
render_mode unshaded;

uniform float width: hint_range(0.0, 20.0);//variable for outline width in pixels
uniform vec4 outline_color: source_color;//this is a vector 4(R,G,B,A) used for the color of the outline


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float size = width * 1.0 / float(textureSize(TEXTURE,0).x);//this sets the outline size based on width variable
	//*1 / texturesize and level of detail(0 for 2d), we take the first value (x) and convert it to float
	vec4 sprite_color = texture(TEXTURE, UV);//we sample the texture and get the alpha here, TEXTURE corresponds
	//to the texture of the sprite, while texture extracts the colors from it
	float alpha = -4.0 * sprite_color.a;//the number is the times we offset and resample the texture (UP,DOWN,LEFT,RIGHT)
	//gets multiplied by the SPRITE'S ALPHA VALUE ( .a is the alpha value)
	alpha += texture(TEXTURE, UV + vec2(size,0.0)).a;//we set the offset here, and we exctract only the alpha(RIGHT)
	alpha += texture(TEXTURE, UV + vec2(0.0,size)).a;//we set the offset here, and we exctract only the alpha(DOWN)
	alpha += texture(TEXTURE, UV + vec2(-size,0.0)).a;//we set the offset here, and we exctract only the alpha(LEFT)
	alpha += texture(TEXTURE, UV + vec2(0.0,-size)).a;//we set the offset here, and we exctract only the alpha(UP)

	vec4 final_color = mix(sprite_color, outline_color, clamp(alpha, 0.0, 1.0));
	COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));//we set the color and the alpha value here
	//we get the absolute value of alpha to avoid negative values and clamp it between 0 and 1 to avoid
	//empty spaces
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
