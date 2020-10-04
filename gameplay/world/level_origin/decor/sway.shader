shader_type canvas_item;

uniform float y_offset = 0.0;
uniform float y_speed = 0.0;
uniform float y_sway = 0.0;

uniform float x_strength = 0.0;


void vertex() {
	if (UV.y == 0.0) {
		float y_initial = VERTEX.y;
		VERTEX.y = y_initial + y_sway * (sin(TIME * y_speed + 0.5 * UV.x + y_offset) + 1.0 / 2.0);
		
		VERTEX.x += x_strength;
	}
}

