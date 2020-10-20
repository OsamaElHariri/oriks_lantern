extends Node2D

const PLAYER_SCENE = preload("res://gameplay/actor/player/player/Player.tscn")
const EMPTY_INPUT = preload("res://gameplay/actor/movement/move_collection/EmptyInput.gd")
const PLAYER_INPUT = preload("res://gameplay/actor/movement/move_collection/PlayerInput.gd")
const PLAYER_FATHER_SCRIPTED_INPUT = preload("res://gameplay/actor/movement/move_collection/PlayerFatherScriptedInput.gd")

var FATHER_TORSO = load("res://gameplay/actor/player/player/father_visuals/torso.png")
var FATHER_HAND = load("res://gameplay/actor/player/player/father_visuals/hand.png")
var FATHER_LEG = load("res://gameplay/actor/player/player/father_visuals/leg.png")


var world_camera
var initial_robot_pos

var player_father
var has_triggered_scene = false
var has_triggered_escape_scene = false

var has_played_look_at_this = false

var father_carrying_player = false

func _ready():
	$Robot.visible = false
	initial_robot_pos = $Robot/CrusherRobot.position
	$CutsceneTrigger.connect("area_entered", self, "on_start_cutscene")
	$PanicCutsceneTrigger.connect("area_entered", self, "on_start_panic_cutscene")
	$LevelOrigin.connect("level_active", self, "on_level_active")
	$LevelOrigin.connect("level_inactive", self, "on_level_inactive")
	world_camera = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera")

func on_level_active():
	$Decor/EnvironmentAnimationPlayer.play("thunder")
	var player = $LevelOrigin.world.player
	player.position.x -= 600
	player.signature_action_enabled = false
	player.get_node("MoveCollection").disable_movement("WallJumpMovement")
	var hat = player.get_node_or_null("Visuals/Sprites/torso/hat")
	player.scale = Vector2.ONE * 0.85
	if hat:
		hat.visible = false
	
	$Robot.visible = true
	var background = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera/ParallaxBackground/ParallaxLayer/background")
	if background:
		background.modulate = Color(0.09, 0.06, 0.91)
	spawn_father()
	$Dialog/DialogAnimationPlayer.play("hey_orik")

func on_level_inactive():
	has_triggered_scene = false
	var player = $LevelOrigin.world.player
	player.signature_action_enabled = true
	player.get_node("MoveCollection").enable_movement("WallJumpMovement")
	var hat = player.get_node_or_null("Visuals/Sprites/torso/hat")
	player.scale = Vector2.ONE
	if hat:
		hat.visible = true
	
	$LevelOrigin.world.get_node("TargetFollower").offset = Vector2.ZERO
	$Robot.visible = false
	var background = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera/ParallaxBackground/ParallaxLayer/background")
	if background:
		background.modulate = Color(1, 1, 1)
	if player_father:
		player_father.queue_free()
		player_father = null
		$Dialog/DialogAnimationPlayer.stop()
		for child in $Dialog.get_children():
			if child.has_method('free_dialog'): child.free_dialog()

func spawn_father():
	player_father = PLAYER_SCENE.instance()
	player_father.world = $LevelOrigin.world
	player_father.get_node("MoveCollection").input = EMPTY_INPUT.new()
	player_father.get_node("LevelTransitionIndicator").collision_layer = 0
	$LevelOrigin.world.player.add_collision_exception_with(player_father)
	
	player_father.get_node("Visuals/Sprites/torso").texture = FATHER_TORSO
	player_father.get_node("Visuals/Sprites/torso/Legs/frontleg").texture = FATHER_LEG
	player_father.get_node("Visuals/Sprites/torso/Legs/frontleg/leg").texture = FATHER_LEG
	player_father.get_node("Visuals/Sprites/torso/Legs/backleg").texture = FATHER_LEG
	player_father.get_node("Visuals/Sprites/torso/Legs/backleg/leg").texture = FATHER_LEG
	player_father.get_node("Visuals/Sprites/torso/hand").texture = FATHER_HAND
	player_father.get_node("Visuals/Sprites/torso/backhand").texture = FATHER_HAND
	player_father.scale = Vector2.ONE * 1.3
	player_father.remove_from_group('player')
	player_father.add_to_group('player_father')
	player_father.position = $CutsceneTrigger.position + Vector2(-230, 450)
	player_father.spirit_player_duration = INF
	call_deferred('add_child', player_father)

func on_start_cutscene(_player_tracker):
	if has_triggered_scene: return
	has_triggered_scene = true
	$LevelOrigin.world.player.get_node("MoveCollection").input = EMPTY_INPUT.new()
	$Dialog/DialogAnimationPlayer.play("explanation")

func anticipation_shake():
	EMITTER.emit("request_screen_shake", 0.5)

func set_camera_follower():
	$LevelOrigin.world.get_node("TargetFollower").offset = Vector2(OS.get_screen_size().x * 0.16, 0)

func robot_trigger():
	$Robot/CrusherRobot/Animations/PositionAnimationPlayer.play("enter")
	EMITTER.emit("request_screen_shake", 0.8)
	$LevelOrigin.world.player.get_node("MoveCollection").input = PLAYER_INPUT.new()
	var father_scripted_input = PLAYER_FATHER_SCRIPTED_INPUT.new()
	player_father.get_node("MoveCollection").input = father_scripted_input
	father_scripted_input.start('explanation')

func on_start_panic_cutscene(_player_tracker):
	if has_triggered_escape_scene: return
	has_triggered_escape_scene = true
	$Dialog/DialogAnimationPlayer.play("panic")

func trigger_father_help_player():
	var father_scripted_input = PLAYER_FATHER_SCRIPTED_INPUT.new()
	player_father.get_node("MoveCollection").input = father_scripted_input
	father_scripted_input.start('escape')

func _physics_process(_delta):
	if player_father and player_father.spirit_player != null:
		$LevelOrigin.world.player.visible = false
		$LevelOrigin.world.player.global_position = player_father.spirit_player.global_position
	else:
		$LevelOrigin.world.player.visible = true
	
	$Decor/screen_center_fade_overlay.visible = $LevelOrigin.is_level_active
	
	if not has_played_look_at_this and $LevelOrigin.is_level_active and $LevelOrigin.world.player.global_position.x < $Dialog/FatherDialog.global_position.x - 200:
		has_played_look_at_this = true
		$Dialog/DialogAnimationPlayer.play("look_at_this")
	
	if world_camera:
		$Robot/CrusherRobot.global_position.x = -get_viewport_transform().get_origin().x + OS.get_screen_size().x
		$Decor/screen_center_fade_overlay.global_position = -get_viewport_transform().get_origin() + OS.get_screen_size() / 2

