extends Node2D

export var gravity = 120
export var max_gravity = 900
export var max_wall_gravity = 100

var current_gravity = 1

func get_velocity(move_collection):
	var current_max_gravity = max_gravity if !move_collection.is_on_wall else max_wall_gravity
	if move_collection.is_on_floor:
		stop()
	else:
		var multiplier = 1 if current_gravity < current_max_gravity else -1
		current_gravity = min(current_gravity + gravity * multiplier * move_collection.time_multiplier, current_max_gravity)
	
	return Vector2(0, current_gravity * move_collection.time_multiplier)

func stop():
	current_gravity = 1
