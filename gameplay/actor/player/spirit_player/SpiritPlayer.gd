extends KinematicBody2D

var original_node
var distance_threshold = 400
var duration = 0.5

var current_duration = 0

var player

func _ready():
	$MoveCollection.input.update(0)

func _physics_process(delta):
	current_duration += delta
	
	var alpha = 1 - ease(current_duration / duration, 1)
	
	$Visual/Sprites.modulate = Color(1, 1, 1, 0.5 + 0.5 * alpha)
	
	if current_duration > duration:
		end_journey()
	elif current_duration > 0.2 and !$MoveCollection.input.action_pressed:
		end_journey()

func end_journey():
	player.spirit_form_end(self)
	queue_free()
