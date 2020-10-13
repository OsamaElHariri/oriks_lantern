extends Node2D

var target = Vector2.ZERO
var tail
var tail_height

func _ready():
	tail = $Visuals/dialog_box_tail
	tail_height = tail.texture.get_size().y

func _process(_delta):
	target = get_global_mouse_position()
	var diff = target - global_position
	tail.rotation = Vector2.UP.angle_to(target)
	tail.scale = Vector2(1, diff.length() / tail_height)
