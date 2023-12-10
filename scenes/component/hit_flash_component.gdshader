// shader custom code
shader_type canvas_item;

// we use this variable to connect to our gd script
// this will allow us to modify the transition for the pixels
// from its original pixel colors to white then back 
// hint_range gives this a range of values lerp_percent can be (from 0 to 100%)
uniform float lerp_percent: hint_range(0.0, 1.0);

// this fragment function runs for every pixel in the shader
void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	// mix is a linear interpolation going from our texture's color to the color white
	// in 1 weight
	// vec4 arguments are RGBA
	vec4 final_color = mix(texture_color, vec4(1.0, 1.0, 1.0, texture_color.a), lerp_percent);
	COLOR = final_color;
}
