extends Node2D

export var speed = 500
export var ramp_up_speed = 150
export var ramp_down_speed = 100

var current_speed = 0
var direction = 0

func get_velocity(move_collection):
	if move_collection.left_pressed and move_collection.right_pressed:
		if move_collection.left_just_pressed_time > move_collection.right_just_pressed_time:
			move_left(move_collection)
		else:
			move_right(move_collection)
	elif move_collection.left_pressed:
		move_left(move_collection)
	elif move_collection.right_pressed:
		move_right(move_collection)
	else:
		current_speed = max(current_speed - ramp_down_speed * sign(current_speed) * move_collection.time_multiplier, 0)
		direction = 0
	
	return Vector2(current_speed  * move_collection.time_multiplier, 0)

func move_left(move_collection):
	direction = -1
	if current_speed > 0: current_speed = 0
	current_speed = max(current_speed - ramp_up_speed * move_collection.time_multiplier, -speed)

func move_right(move_collection):
	direction = 1
	if current_speed < 0: current_speed = 0
	current_speed = min(current_speed + ramp_up_speed * move_collection.time_multiplier, speed)

func stop():
	current_speed = 0
