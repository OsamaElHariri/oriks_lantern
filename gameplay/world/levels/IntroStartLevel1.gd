extends Node2D


const EMPTY_INPUT = preload("res://gameplay/actor/movement/move_collection/EmptyInput.gd")
const PLAYER_INPUT = preload("res://gameplay/actor/movement/move_collection/PlayerInput.gd")

var pan_amount = 1300
var current_pan_amount = 0
var is_panning = false

var has_set_input = false

func _ready():
	current_pan_amount = pan_amount
	$LevelOrigin.world.get_node("TargetFollower").offset = Vector2(0, -current_pan_amount)
	$LevelOrigin.world.get_node("TargetFollower").snap_camera = true
	$LevelOrigin.connect("level_inactive", self, "on_level_inactive")

func on_level_inactive():
	$LevelOrigin.world.stop_wildlife_loop()

func _process(delta):
	if not is_panning:
		$LevelOrigin.world.player.get_node("MoveCollection").input = EMPTY_INPUT.new()
	
	if is_panning and current_pan_amount > 0:
		$LevelOrigin.world.player.get_node("MoveCollection").input = EMPTY_INPUT.new()
		current_pan_amount = max(0, current_pan_amount - pan_amount * delta * 0.5)
		$LevelOrigin.world.get_node("TargetFollower").offset = Vector2(0, -current_pan_amount)
	
	if not is_panning and Input.is_action_pressed("ui_accept"):
		is_panning = true
	
	if not has_set_input and current_pan_amount == 0:
		has_set_input = true
		$LevelOrigin.world.player.get_node("MoveCollection").input = PLAYER_INPUT.new()
