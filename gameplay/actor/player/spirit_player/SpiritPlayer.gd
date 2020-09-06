extends KinematicBody2D

var original_node
var distance_threshold = 400

func _ready():
	$MoveCollection.update()
	$MoveCollection.connect("player_dash_init", self, "on_player_dash_init")
	

func on_player_dash_init():
	$DashWindUpAnimationPlayer.play("DashWindUp")

func _physics_process(delta):
	if original_node != null and is_too_far(original_node):
		end_journey()
	elif !Input.is_action_pressed("dash"):
		end_journey()

func is_too_far(node):
	return position.distance_to(node.position) > distance_threshold

func end_journey():
	EMITTER.emit('spirit_journey_end', self)
	queue_free()
