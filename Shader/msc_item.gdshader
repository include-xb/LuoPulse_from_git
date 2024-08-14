shader_type canvas_item;

uniform vec4 albedo_color = vec4(0.0, 0.0, 0.0, 0.0);		//基础色
uniform float transparency : hint_range(0.0, 1.0) = 0.5;	// 透明度
uniform vec2 distortion = vec2(0.01, 0.01); 				// 模糊程度

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// 采样纹理颜色
	vec4 tex_color = texture(TEXTURE, UV);
	
	// 应用透明度
	tex_color.a *= transparency;
	
	// 应用模糊效果，模拟亚克力的折射
	vec2 distorted_uv = UV + distortion * tex_color.a;
	vec4 distorted_color = texture(TEXTURE, distorted_uv);
	
	// 将纹理颜色与基础颜色结合，并应用模糊效果
	vec4 final_color = mix(tex_color, distorted_color, 0.5);
	
	// 设置像素的最终颜色
	COLOR = final_color;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
