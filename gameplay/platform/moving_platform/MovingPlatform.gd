extends KinematicBody2D


var initial_position
func _ready():
	initial_position = position


func _physics_process(delta):
	position += Vector2.DOWN * 100 * delta
	if abs(position.y - initial_position.y) > 2900:
		position = initial_position
