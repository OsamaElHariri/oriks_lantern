extends KinematicBody2D

var original_node
var distance_threshold = 400
var duration = 0.5

var current_duration = 0

func _ready():
	$MoveCollection.input_update()
	$MoveCollection.connect("player_dash_init", self, "on_player_dash_init")
	

func on_player_dash_init():
	$DashWindUpAnimationPlayer.play("DashWindUp")

func _physics_process(delta):
	current_duration += delta
	
	var alpha = 1 - ease(current_duration / duration, 1)
	
	$Visual/Sprites.modulate = Color(1, 1, 1, 0.2 + 0.8 * alpha)
	
	if current_duration > duration:
		end_journey()
	elif !Input.is_action_pressed("dash"):
		end_journey()

func end_journey():
	EMITTER.emit('spirit_journey_end', self)
	queue_free()
