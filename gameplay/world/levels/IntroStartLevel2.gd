extends Node2D

const PLAYER_SCENE = preload("res://gameplay/actor/player/player/Player.tscn")
const EMPTY_INPUT = preload("res://gameplay/actor/movement/move_collection/EmptyInput.gd")

var FATHER_TORSO = load("res://gameplay/actor/player/player/father_visuals/torso.png")
var FATHER_HAND = load("res://gameplay/actor/player/player/father_visuals/hand.png")
var FATHER_LEG = load("res://gameplay/actor/player/player/father_visuals/leg.png")


var world_camera
var initial_robot_pos

var player_father

func _ready():
	$Robot.visible = false
	initial_robot_pos = $Robot/CrusherRobot.position
	$Robot/Area2D.connect("area_entered", self, "on_robot_trigger")
	$LevelOrigin.connect("level_active", self, "on_level_active")
	$LevelOrigin.connect("level_inactive", self, "on_level_inactive")
	world_camera = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera")

func on_level_active():
	var player = $LevelOrigin.world.player
	var hat = player.get_node_or_null("Visuals/Sprites/torso/hat")
	player.scale = Vector2.ONE * 0.85
	if hat:
		hat.visible = false
	
	$Robot.visible = true
	var background = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera/ParallaxBackground/ParallaxLayer/background")
	if background:
		background.modulate = Color(0.09, 0.06, 0.91)
	
	player_father = PLAYER_SCENE.instance()
	player_father.world = $LevelOrigin.world
	player_father.get_node("MoveCollection").input = EMPTY_INPUT.new()
	player_father.get_node("LevelTransitionIndicator").collision_layer = 0
	
	player_father.get_node("Visuals/Sprites/torso").texture = FATHER_TORSO
	player_father.get_node("Visuals/Sprites/torso/Legs/frontleg").texture = FATHER_LEG
	player_father.get_node("Visuals/Sprites/torso/Legs/frontleg/leg").texture = FATHER_LEG
	player_father.get_node("Visuals/Sprites/torso/Legs/backleg").texture = FATHER_LEG
	player_father.get_node("Visuals/Sprites/torso/Legs/backleg/leg").texture = FATHER_LEG
	player_father.get_node("Visuals/Sprites/torso/hand").texture = FATHER_HAND
	player_father.get_node("Visuals/Sprites/torso/backhand").texture = FATHER_HAND
	player_father.scale = Vector2.ONE * 1.3
	call_deferred('add_child', player_father)

func on_level_inactive():
	var player = $LevelOrigin.world.player
	var hat = player.get_node_or_null("Visuals/Sprites/torso/hat")
	player.scale = Vector2.ONE
	if hat:
		hat.visible = true
	
	$Robot.visible = false
	var background = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera/ParallaxBackground/ParallaxLayer/background")
	if background:
		background.modulate = Color(1, 1, 1)

func on_robot_trigger(_player_tracker):
	$Robot/CrusherRobot/Animations/PositionAnimationPlayer.play("enter")
	EMITTER.emit("request_screen_shake", 0.8)

func _physics_process(_delta):
	if world_camera:
		$Robot/CrusherRobot.global_position.x = -get_viewport_transform().get_origin().x + OS.get_screen_size().x

