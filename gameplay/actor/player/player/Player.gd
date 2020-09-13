extends KinematicBody2D

var SPIRIT_PLAYER = load("res://gameplay/actor/player/spirit_player/SpiritPlayer.tscn")

var can_summon_spirit = false
var is_charging_spirit = INF
var ignore_area_enter
var near_wall = null

var horizontal_movement = null

func _ready():
	$MoveCollection.connect("player_dash_init", self, "on_player_dash_init")
	$MoveCollection.connect("player_dash_start", self, "on_player_dash_start")
	$MoveCollection.connect("player_dash_short_circuit", self, "on_player_dash_short_circuit")
	EMITTER.connect("spirit_journey_end", self, "on_spirit_journey_end")
	horizontal_movement = $MoveCollection.get_movement("HorizontalMovement")

func on_player_dash_init():
	EMITTER.emit("player_dash_init", self)
	$DashWindUpAnimationPlayer.play("DashWindUp")
	$CollisionShape2D.disabled = true

func on_player_dash_start():
	EMITTER.emit("player_dash_start", self)

func on_player_dash_short_circuit():
	EMITTER.emit("player_dash_init", self)
	$CollisionShape2D.disabled = true
	$DashWindUpAnimationPlayer.play("DashWindUp")
	is_charging_spirit = 0
	$MoveCollection.time_multiplier = 0
	$MoveCollection.lock_controls = true

func summon_spirit_player():
	$MoveCollection.time_multiplier = 0
	$CollisionShape2D.disabled = true
	modulate = Color(1, 1, 1, 0)
	EMITTER.emit("player_dash_start", self)
	var spirit_player = SPIRIT_PLAYER.instance()
	ignore_area_enter = spirit_player
	get_parent().add_child(spirit_player)
	spirit_player.position = position
	can_summon_spirit = false

func on_spirit_journey_end(spirit_player):
	position = spirit_player.position
	$MoveCollection.time_multiplier = 1
	modulate = Color(1, 1, 1, 1)
	$CollisionShape2D.disabled = false
	var move_collection = $MoveCollection
	move_collection.lock_controls = false
	move_collection.stop_movement("GravityMovement")
	move_collection.stop_movement("JumpMovement")
	move_collection.stop_movement("WallJumpMovement")
	var movement = move_collection.add_follow_through_movement()
	movement.strength = 550
	movement.strength_decay = 100
	can_summon_spirit = false
	
	movement.direction = spirit_player.get_node('MoveCollection').velocity

func _physics_process(_delta):
	is_charging_spirit += 1
	if is_charging_spirit == 5:
		summon_spirit_player()
	
	near_wall = null
	for body in $WallCheckArea.get_overlapping_bodies():
		if body.is_in_group("wall_jump_platform"):
			near_wall = body
	
	if is_on_floor() or near_wall != null:
		can_summon_spirit = true
	
	if can_summon_spirit and Input.is_action_just_pressed("dash"):
		on_player_dash_short_circuit()
	
	handle_visuals()

func handle_visuals():
	var visual_scale = $Visuals.scale
	if horizontal_movement.direction != 0:
		$AnimationPlayer.play("walk")
		$AnimationPlayer.playback_speed = 0.7
	else:
		$AnimationPlayer.play("base")
		$AnimationPlayer.playback_speed = 1
	
	if horizontal_movement.direction < 0:
		$Visuals.scale = Vector2(-abs(visual_scale.x), visual_scale.y)
	elif horizontal_movement.direction > 0:
		$Visuals.scale = Vector2(abs(visual_scale.x), visual_scale.y)
