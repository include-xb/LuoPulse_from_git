
shader_type canvas_item;
render_mode unshaded;
uniform vec2 texture_size;
uniform float radius;
bool check(vec2 texCoord) {
	vec2 pos = vec2(texCoord.x*texture_size.x, (1.0 - texCoord.y)*texture_size.y);
	if (pos.x > radius && pos.x < texture_size.x - radius){
		return true;
		}else if(pos.y > radius && pos.y < texture_size.y - radius){
			return true;
			}else if(pow(pos.x - radius,2.0) + pow(pos.y - radius,2.0) <= pow(radius, 2.0)){
				return true;
				}else if(pow(pos.x - (texture_size.x - radius),2.0) + pow(pos.y - radius,2.0) <= pow(radius, 2.0)){
					return true;
					}else if(pow(pos.x - radius,2.0) + pow(pos.y - (texture_size.y - radius),2.0) <= pow(radius, 2.0)){
						return true;
						}else if(pow(pos.x - (texture_size.x - radius),2.0) + pow(pos.y - (texture_size.y - radius),2.0) <= pow(radius, 2.0)){
							return true;
							}
							return false;
							}
							
							
void fragment(){
	COLOR = texture(TEXTURE, UV);
	if(!check(UV)) {
		COLOR *= vec4(0, 0, 0, 0);
		}
	}
