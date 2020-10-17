extends Node2D


var target = null
var offset = Vector2.ZERO

func _process(_delta):
	if target:
		global_position = target.global_position + offset
