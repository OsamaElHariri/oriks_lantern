extends Node2D

export var speed = 800
export var ramp_up_speed = 200
export var ramp_down_speed = 120

var current_speed = 0

func get_velocity(move_collection):
	if move_collection.is_dashing or move_collection.is_charging_dash:
		return Vector2(0, 0)
	
	
	if move_collection.left_pressed:
		if current_speed > 0: current_speed = 0
		current_speed = max(current_speed - ramp_up_speed * move_collection.time_multiplier, -speed)
	elif move_collection.right_pressed:
		if current_speed < 0: current_speed = 0
		current_speed = min(current_speed + ramp_up_speed * move_collection.time_multiplier, speed)
	else:
		current_speed = max(current_speed - ramp_down_speed * sign(current_speed) * move_collection.time_multiplier, 0)
	
	
	return Vector2(current_speed  * move_collection.time_multiplier, 0)
