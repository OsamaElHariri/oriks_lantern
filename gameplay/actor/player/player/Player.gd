extends KinematicBody2D

var SPIRIT_PLAYER = load("res://gameplay/actor/player/spirit_player/SpiritPlayer.tscn")

var can_summon_spirit = false
var is_charging_spirit = INF
var ignore_area_enter
var near_wall = null

func _ready():
	$MoveCollection.connect("player_dash_init", self, "on_player_dash_init")
	$MoveCollection.connect("player_dash_start", self, "on_player_dash_start")
	$MoveCollection.connect("player_dash_short_circuit", self, "on_player_dash_short_circuit")
	EMITTER.connect("spirit_journey_end", self, "on_spirit_journey_end")
#	$Area2D.connect("body_entered", self, "on_body_entered")

func on_player_dash_init():
	EMITTER.emit("player_dash_init")
	$DashWindUpAnimationPlayer.play("DashWindUp")
	$CollisionShape2D.disabled = true

func on_player_dash_start():
	EMITTER.emit("player_dash_start")

func on_player_dash_short_circuit():
	EMITTER.emit("player_dash_init")
	$CollisionShape2D.disabled = true
	$DashWindUpAnimationPlayer.play("DashWindUp")
	is_charging_spirit = 0
	$MoveCollection.time_multiplier = 0
	$MoveCollection.lock_controls = true

func summon_spirit_player():
	$MoveCollection.time_multiplier = 0
	$CollisionShape2D.disabled = true
	modulate = Color(1, 1, 1, 0)
	EMITTER.emit("player_dash_start")
	var spirit_player = SPIRIT_PLAYER.instance()
	ignore_area_enter = spirit_player
	get_parent().add_child(spirit_player)
	spirit_player.position = position
	spirit_player.original_node = self
	can_summon_spirit = false

func on_spirit_journey_end(spirit_player):
	position = spirit_player.position
	$MoveCollection.time_multiplier = 1
	modulate = Color(1, 1, 1, 1)
	$CollisionShape2D.disabled = false
	$MoveCollection.lock_controls = false
	$MoveCollection/JumpMovement.current_strength = 0
	$MoveCollection/WallJumpMovement.current_strength = 0
	$MoveCollection/GravityMovement.reset_gravity()
	var movement = $MoveCollection.add_follow_through_movement()
	movement.strength = 550
	movement.strength_decay = 100
	
	movement.direction = spirit_player.get_node('MoveCollection').velocity

func _physics_process(delta):
	is_charging_spirit += 1
	
	if is_charging_spirit == 5:
		summon_spirit_player()
	
	if is_on_floor():
		can_summon_spirit = true
	
	if can_summon_spirit and Input.is_action_just_pressed("dash"):
		on_player_dash_short_circuit()
	
	near_wall = null
	for body in $WallCheckArea.get_overlapping_bodies():
		if body.is_in_group("wall_jump_platform"):
			near_wall = body
