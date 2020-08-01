extends Node2D

export var gravity = 120
export var max_gravity = 1800

var current_gravity = 1

func get_velocity(move_collection):
	if move_collection.is_on_floor or move_collection.is_dashing or move_collection.is_charging_dash:
		current_gravity = 1
	else:
		current_gravity = min(current_gravity + gravity, max_gravity)
	
	return Vector2(0, current_gravity)
