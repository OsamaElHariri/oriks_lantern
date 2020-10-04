extends Node2D

export(Curve) var smooth
export(Curve) var hard_start

var forces = {}
var visual_texture_size
var visual_material

var spirit_pulse_range = 600

func _ready():
	visual_texture_size = $visual.texture.get_size()
	$visual.material = $visual.material.duplicate(true)
	
	visual_material = $visual.material
	visual_material.set_shader_param("y_offset", randi() % 100)
	visual_material.set_shader_param("y_speed_offset", randf() - 0.5)
	EMITTER.connect("player_spirit_form_start", self, 'on_player_spirit_form_start')

func on_player_spirit_form_start(player):
	var diff = global_position.x - player.global_position.x
	if abs(diff) < spirit_pulse_range:
		add_force((1 - abs(diff) / spirit_pulse_range) * 0.3 * sign(diff) * sign(scale.x), hard_start, 3)

func add_force(force, curve, duration):
	forces[force] = {
		'force': force,
		'duration': 0,
		'max_duration': duration,
		'curve': curve
	}

func _process(delta):
	var total_force = 0
	for key in forces.keys():
		var force = forces[key]
		force['duration'] += delta
		
		if force['duration'] > force['max_duration']:
			forces.erase(key)
		else:
			total_force += force['force'] * force['curve'].interpolate(force['duration'] / force['max_duration'])
	
	total_force = clamp(total_force, -2, 2)
	visual_material.set_shader_param("x_strength", total_force * visual_texture_size.x / 2)
