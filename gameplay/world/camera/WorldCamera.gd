extends Camera2D

var is_narrowing = false
var previous_position = Vector2.ZERO
var velocity = Vector2.ZERO

func _physics_process(_delta):
	if is_narrowing:
		zoom = zoom - (zoom - Vector2(0.97, 0.97)) * 0.2
	else:
		zoom = zoom - (zoom - Vector2(1, 1)) * 0.6
	
	var canvas_pos = get_viewport_transform().get_origin()
	velocity = previous_position - canvas_pos
	previous_position = canvas_pos
