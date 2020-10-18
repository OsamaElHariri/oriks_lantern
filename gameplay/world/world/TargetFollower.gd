extends Node2D


var target = null
var offset = Vector2.ZERO

var limit_left
var limit_right
var limit_top
var limit_bottom

var screen_size

func _ready():
	screen_size = OS.get_screen_size()

func _process(_delta):
	if target:
		global_position = target.global_position + offset
	
	if limit_right and limit_left and limit_right - limit_left < screen_size.x:
		global_position.x = (limit_right + limit_left) / 2
	else:
		if limit_left:
			global_position.x = max(limit_left + screen_size.x / 2, global_position.x)
		if limit_right:
			global_position.x = min(limit_right - screen_size.x / 2, global_position.x)
	
	if limit_bottom and limit_top and limit_bottom - limit_top < screen_size.y:
		global_position.y = (limit_bottom + limit_top) / 2
	else:
		if limit_top:
			global_position.y = max(limit_top + screen_size.y / 2, global_position.y)
		if limit_bottom:
			global_position.y = min(limit_bottom - screen_size.y / 2, global_position.y)
