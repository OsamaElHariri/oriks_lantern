extends Node2D

export var x_strength = 1600
export var y_strength = 2100
export var x_strength_decay = 80
export var y_strength_decay = 50

var current_strength = Vector2.ZERO

var x_direction = 0

func get_velocity(move_collection):
	var decay = Vector2(x_strength_decay, y_strength_decay) * move_collection.time_multiplier
	current_strength = Vector2(max(current_strength.x - decay.x, 0), max(current_strength.y - decay.y, 0))
	
	if move_collection.is_on_floor or move_collection.is_on_wall:
		stop()
	
	if !move_collection.is_on_floor and move_collection.target.near_wall != null && move_collection.jump_just_pressed:
		current_strength = Vector2(x_strength, y_strength)
		move_collection.reset_gravity()
		x_direction = sign(move_collection.target.global_position.x - move_collection.target.near_wall.global_position.x)

	if move_collection.is_dashing or move_collection.is_charging_dash:
		stop()
	
	return Vector2(x_direction, -1) * current_strength * move_collection.time_multiplier

func stop():
	current_strength = Vector2.ZERO
