extends Node2D


var target = null

func _process(_delta):
	if target:
		position = target.position
