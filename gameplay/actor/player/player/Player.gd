extends KinematicBody2D

var SPIRIT_PLAYER = load("res://gameplay/actor/player/spirit_player/SpiritPlayer.tscn")

var can_summon_spirit = false
var is_charging_spirit = INF
var ignore_area_enter
var near_wall = null

var horizontal_movement = null

var spirit_player = null

var jump_just_pressed_counter = INF

var world

func _ready():
	$WindUpAnimationTimer.connect("timeout", self, "spirit_form_start")
	horizontal_movement = $MoveCollection.get_movement("HorizontalMovement")

func spirit_form_wind_up():
	$WindUpAnimationPlayer.play("wind_up")
	$WindUpAnimationTimer.start()
	$MoveCollection.time_multiplier = 0
	can_summon_spirit = false
	world.spirit_form_wind_up(self)

func spirit_form_start():
	$MoveCollection.time_multiplier = 0
	$CollisionShape2D.disabled = true
	modulate = Color(1, 1, 1, 0)
	spirit_player = SPIRIT_PLAYER.instance()
	ignore_area_enter = spirit_player
	get_parent().add_child(spirit_player)
	spirit_player.position = position
	spirit_player.player = self
	can_summon_spirit = false
	world.spirit_form_start(self)

func spirit_form_end(spirit):
	position = spirit.position
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
	world.spirit_form_end(self)
	
	movement.direction = spirit_player.get_node('MoveCollection').velocity
	spirit_player = null

func _physics_process(delta):
	check_near_walls()
	
	if spirit_player == null and (is_on_floor() or near_wall != null) and $WindUpAnimationTimer.time_left == 0:
		can_summon_spirit = true
	
	if Input.is_action_just_pressed("signature_action"):
		jump_just_pressed_counter = 0
	jump_just_pressed_counter += delta
	
	if can_summon_spirit and jump_just_pressed_counter < 0.15:
		jump_just_pressed_counter = INF
		spirit_form_wind_up()
	
	handle_visuals()

func check_near_walls():
	near_wall = null
	for body in $WallCheckArea.get_overlapping_bodies():
		if body.is_in_group("wall_jump_platform"):
			near_wall = body

func handle_visuals():
	var visual_scale = $Visuals.scale
	var on_floor = is_on_floor()
	var on_wall = is_on_wall()
	if !on_wall and !on_floor:
		if $MoveCollection.velocity.y < 0:
			$AnimationPlayer.play("ascend")
			$AnimationPlayer.playback_speed = 1
		else:
			$AnimationPlayer.play("fall")
			$AnimationPlayer.playback_speed = 1.5
	elif on_wall and !on_floor:
		$AnimationPlayer.play("wall_hang")
		$AnimationPlayer.playback_speed = 1
	elif horizontal_movement.direction != 0:
		$AnimationPlayer.play("walk")
		$AnimationPlayer.playback_speed = 0.7
	else:
		$AnimationPlayer.play("idle")
		$AnimationPlayer.playback_speed = 0.7
	
	if horizontal_movement.direction < 0:
		$Visuals.scale = Vector2(-abs(visual_scale.x), visual_scale.y)
	elif horizontal_movement.direction > 0:
		$Visuals.scale = Vector2(abs(visual_scale.x), visual_scale.y)

func trigger_defeat(_body):
	if spirit_player != null:
		spirit_player.queue_free()
	world.player_defeat_and_respawn()
	
