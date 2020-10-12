extends Node2D

export var speed = 800

var is_initialized = false
var direction = Vector2(0, -1)
var target_direction = Vector2(0, -1)
var lerp_delta = 0.2

func get_velocity(move_collection):
	var input = move_collection.input
	var new_target_direction = Vector2(0, 0)
	
	if input.left_pressed:
		new_target_direction.x = -1
	elif input.right_pressed:
		new_target_direction.x = 1
	
	if input.up_pressed:
		new_target_direction.y = -1
	elif input.down_pressed:
		new_target_direction.y = 1
	
	if new_target_direction.x != 0 or new_target_direction.y != 0:
		target_direction = new_target_direction
	
	
	if !is_initialized: direction = target_direction
	is_initialized = true
	
	direction = direction.linear_interpolate(target_direction, lerp_delta)
	
	return direction.normalized() * speed * move_collection.time_multiplier
