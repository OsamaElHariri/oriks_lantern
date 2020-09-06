extends Node2D


var direction = Vector2(0, 0)
var strength = 100
var strength_decay = 100

var min_strength = 0
var max_strength = INF

func get_velocity(move_collection):
	strength = clamp(strength - strength_decay * move_collection.time_multiplier, min_strength, max_strength)
	return direction.normalized() * strength * move_collection.time_multiplier
