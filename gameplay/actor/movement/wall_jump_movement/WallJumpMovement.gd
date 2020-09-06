extends Node2D

export var strength = 2300
export var strength_decay = 50

var current_strength = 0

var current_direction = Vector2.UP

func get_velocity(move_collection):
	var decay = strength_decay
	current_strength = max(current_strength - decay * move_collection.time_multiplier, 0)
	
	if move_collection.is_on_floor or move_collection.is_on_wall:
		current_strength = 0
	
	if !move_collection.is_on_floor and move_collection.target.near_wall != null && move_collection.jump_just_pressed:
		current_strength = strength
		move_collection.reset_gravity()
		var wall_direction = sign(move_collection.target.near_wall.global_position.x - move_collection.target.global_position.x)
		current_direction = Vector2(0.4 * wall_direction, 1).normalized()

	if move_collection.is_dashing or move_collection.is_charging_dash:
		current_strength = 0
	
	return current_direction * -current_strength * move_collection.time_multiplier
