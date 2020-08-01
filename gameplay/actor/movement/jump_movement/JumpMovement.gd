extends Node2D

export var strength = 2000
export var strength_decay = 50

var current_strength = 0

func get_velocity(move_collection):
	var decay = strength_decay if Input.is_action_pressed("jump") else strength_decay * 4
	current_strength = max(current_strength - decay, 0)
	
	if move_collection.is_on_floor:
		current_strength = 0
	
	if move_collection.is_on_floor && Input.is_action_just_pressed("jump"):
		current_strength = strength
	
	if move_collection.is_dashing or move_collection.is_charging_dash:
		current_strength = 0
	
	return Vector2(0, -current_strength)
