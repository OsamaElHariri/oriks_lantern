extends Node2D

export var strength = 2000
export var strength_decay = 50

var current_strength = 0

func get_velocity(move_collection):
	var decay = strength_decay if move_collection.jump_pressed else strength_decay * 4
	current_strength = max(current_strength - decay * move_collection.time_multiplier, 0)
	
	if move_collection.is_on_floor or move_collection.is_on_wall:
		stop()
	
	if move_collection.is_on_floor && move_collection.jump_just_pressed:
		current_strength = strength
	
	if move_collection.is_dashing or move_collection.is_charging_dash:
		stop()
	
	return Vector2(0, -current_strength * move_collection.time_multiplier)

func stop():
	current_strength = 0
