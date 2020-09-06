extends Node2D

export var gravity = 120
export var max_gravity = 1800

var current_gravity = 1

func get_velocity(move_collection):
	var current_max_gravity = max_gravity if !move_collection.is_on_wall else 200
	if move_collection.is_on_floor or move_collection.is_dashing or move_collection.is_charging_dash:
		reset_gravity()
	else:
		current_gravity = min(current_gravity + gravity * move_collection.time_multiplier, current_max_gravity)
	
	return Vector2(0, current_gravity * move_collection.time_multiplier)

func reset_gravity():
	current_gravity = 1
