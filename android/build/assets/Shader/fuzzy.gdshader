shader_type canvas_item; 

float normpdf(in float x, in float sigma){ 
	return 0.39894*exp(-.5*x*x/(sigma*sigma))/sigma; 
} 

vec4 gaussian_blur(sampler2D src, vec2 size, vec2 uv, int m_size){ 
	vec4 cc = texture(src, uv); 
	vec3 c = cc.rgb; 
	int k_size = (m_size-1)/2; 
	float sigma = 7.; 
	vec3 final_color = vec3(0.); 
	float z = 0.; 
	for(int i=-k_size;i<=k_size;i++){ 
		float n = normpdf(float(i), sigma); 
		z+=n; 
		for(int j=-k_size;j<=k_size;j++){ 
			final_color+=n*n*texture(src,uv+size*vec2(float(i),float(j))).rgb; 
		} 
	} 
	return vec4(final_color/z/z,1.); 
} 

void fragment(){ 
	COLOR = gaussian_blur(TEXTURE ,TEXTURE_PIXEL_SIZE ,UV , 10); 
}
