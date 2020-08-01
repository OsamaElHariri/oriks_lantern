extends Node2D

export var speed = 500

func get_velocity(move_collection):
	if move_collection.is_dashing or move_collection.is_charging_dash:
		return Vector2(0, 0)
	
	var current_speed = speed * move_collection.time_multiplier
	if move_collection.left_pressed:
		return Vector2(-current_speed, 0)
	elif move_collection.right_pressed:
		return Vector2(current_speed, 0)
	
	return Vector2(0, 0)
