extends Node2D

export var strength = 2100
export var strength_decay = 50

var current_strength = 0

var near_wall = null

func get_velocity(move_collection):
	var decay = strength_decay if move_collection.jump_pressed else strength_decay * 4
	if (move_collection.is_on_wall and move_collection.target.near_wall == near_wall) \
		or (move_collection.target.near_wall != null && move_collection.target.near_wall != near_wall):
		decay *= 3
	
	current_strength = max(current_strength - decay * move_collection.time_multiplier, 0)
	
	if move_collection.is_on_floor:
		stop()
	
	if move_collection.is_on_floor && move_collection.jump_just_pressed:
		current_strength = strength
		near_wall = move_collection.target.near_wall
	
	if move_collection.is_dashing or move_collection.is_charging_dash:
		stop()
	
	return Vector2(0, -current_strength * move_collection.time_multiplier)

func stop():
	current_strength = 0
