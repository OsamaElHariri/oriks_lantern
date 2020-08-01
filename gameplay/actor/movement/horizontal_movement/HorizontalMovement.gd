extends Node2D

export var speed = 500

func get_velocity(move_collection):
	if move_collection.is_dashing or move_collection.is_charging_dash:
		return Vector2(0, 0)
	
	if Input.is_action_pressed("ui_left"):
		return Vector2(-speed, 0)
	elif Input.is_action_pressed("ui_right"):
		return Vector2(speed, 0)
	
	return Vector2(0, 0)
