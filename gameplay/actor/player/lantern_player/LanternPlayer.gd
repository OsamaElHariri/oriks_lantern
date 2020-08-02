extends KinematicBody2D

var SPIRIT_PLAYER = load("res://gameplay/actor/player/spirit_player/SpiritPlayer.tscn")

var ignore_area_enter

func _ready():
	$MoveCollection.connect("player_dash_init", self, "on_player_dash_init")
	$MoveCollection.connect("player_dash_start", self, "on_player_dash_start")
	$MoveCollection.connect("player_dash_short_circuit", self, "on_player_dash_short_circuit")
	$Area2D.connect("body_entered", self, "on_body_entered")

func on_player_dash_init():
	EMITTER.emit("player_dash_init")

func on_player_dash_start():
	EMITTER.emit("player_dash_start")

func on_player_dash_short_circuit():
	$MoveCollection.time_multiplier = 0.005
	$MoveCollection.lock_controls = true
	var spirit_player = SPIRIT_PLAYER.instance()
	ignore_area_enter = spirit_player
	get_parent().add_child(spirit_player)
	spirit_player.position = position

func on_body_entered(body):
	if ignore_area_enter and ignore_area_enter.get_instance_id() == body.get_instance_id():
		ignore_area_enter = null
		return
	
	body.queue_free()
	$MoveCollection.time_multiplier = 1
	$MoveCollection.lock_controls = false
	$MoveCollection.update()
	$MoveCollection/DashMovement.should_short_circuit = false
	$MoveCollection/DashMovement.init_dash($MoveCollection)
