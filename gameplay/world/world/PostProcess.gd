extends TextureRect

var radius = 0
var pulse_thickness = 0

var grey_scale = 0
var grey_direction = -1

func _ready():
	rect_size = get_viewport_rect().size

func spirit_form_start(player):
	radius = 0
	pulse_thickness = 40
	grey_scale = clamp(grey_scale, 0, 1)
	var screen_origin = player.get_global_transform_with_canvas().origin
	var origin = Vector2(screen_origin.x, rect_size.y - screen_origin.y)
	material.set_shader_param("origin", origin)

func spirit_form_end(_player):
	grey_scale = clamp(grey_scale, 0, 1)

func _physics_process(delta):
	grey_scale += 20 * grey_direction * delta
	grey_scale = clamp(grey_scale, 0, 1)
	radius += 1000 * delta
	pulse_thickness -= 90 * delta
	
	material.set_shader_param("ring_radius", radius)
	material.set_shader_param("ring_thickness", max(0, pulse_thickness))
	material.set_shader_param("grey_scale", clamp(grey_scale, 0, 1))
		

