extends Node2D

export(Curve) var smooth
export(Curve) var hard_start

export (Array, Texture) var variations = []

export var x_strength_multiplier = 1.0
export var height_sway_ratio = 0.0
export var y_speed = 0.0
export var y_speed_random = 0.0

export var move_sway_range_multiplier = 1.0

var forces = {}
var visual_texture_size
var visual_material

var move_sway_range = 100
var spirit_pulse_range = 600

func _ready():
	if variations.size() > 0:
		$visual.texture = variations[randi() % variations.size()]
	visual_texture_size = $visual.texture.get_size()
	$visual.material = $visual.material.duplicate(true)
	
	move_sway_range = visual_texture_size.x * move_sway_range_multiplier
	
	visual_material = $visual.material
	visual_material.set_shader_param("y_offset", randi() % 100)
	visual_material.set_shader_param("y_speed", y_speed + randf() * y_speed_random)
	visual_material.set_shader_param("y_sway", height_sway_ratio * visual_texture_size.y / 2)
	EMITTER.connect("player_movement_heartbeat", self, 'on_player_movement_heartbeat')
	EMITTER.connect("player_spirit_form_start", self, 'on_player_spirit_form_start')

func on_player_movement_heartbeat(player):
	var direction = player.horizontal_movement.direction
	var diff = global_position.x - player.global_position.x
	var dist = global_position.distance_to(player.global_position)
	
	if dist < move_sway_range:
		add_force((1 - abs(diff) / spirit_pulse_range) * 1.0 * direction * sign(scale.x), smooth, 2)

func on_player_spirit_form_start(player):
	var diff = global_position.x - player.global_position.x
	var dist = global_position.distance_to(player.global_position)
	if dist < spirit_pulse_range:
		add_force((1 - abs(diff) / spirit_pulse_range) * 1.5 * sign(diff) * sign(scale.x), hard_start, 3)

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
		if force['duration'] <= 0:
			continue
		if force['duration'] > force['max_duration']:
			forces.erase(key)
		else:
			total_force += force['force'] * force['curve'].interpolate(force['duration'] / force['max_duration'])
	
	total_force = clamp(total_force, -2, 2)
	visual_material.set_shader_param("x_strength", total_force * x_strength_multiplier * visual_texture_size.x / 2)
