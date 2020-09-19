extends Node2D


var target = null

func _process(_delta):
	if target:
		global_position = target.global_position
