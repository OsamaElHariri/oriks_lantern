extends Camera2D

var is_narrowing = false

func _physics_process(_delta):
	if is_narrowing:
		zoom = zoom - (zoom - Vector2(0.97, 0.97)) * 0.2
	else:
		zoom = zoom - (zoom - Vector2(1, 1)) * 0.6
