extends KinematicBody2D

var SPIRIT_PLAYER = load("res://gameplay/actor/player/spirit_player/SpiritPlayer.tscn")

var can_summon_spirit = false
var is_charging_spirit = INF
var ignore_area_enter
var near_wall = null

var horizontal_movement = null

var spirit_player_duration = 0.5
var spirit_player = null

var world

var on_floor = true
var on_wall = false

var movement_heartbeat_interval = 0.3
var movement_heartbeat_counter = 0

var level_transition_indicator

var signature_action_enabled = true

func _ready():
	$WindUpAnimationTimer.connect("timeout", self, "spirit_form_start")
	horizontal_movement = $MoveCollection.get_movement("HorizontalMovement")
	level_transition_indicator = $LevelTransitionIndicator

func spirit_form_wind_up():
	$WindUpAnimationPlayer.play("wind_up")
	$WindUpAnimationTimer.start()
	$MoveCollection.time_multiplier = 0
	can_summon_spirit = false
	world.spirit_form_wind_up(self)

func spirit_form_start():
	$SpiritFormAudio.pitch_scale = 0.95 + randf() * 0.1
	$SpiritFormAudio.play()
	$MoveCollection.time_multiplier = 0
	$CollisionShape2D.disabled = true
	modulate = Color(1, 1, 1, 0)
	spirit_player = SPIRIT_PLAYER.instance()
	spirit_player.duration = spirit_player_duration
	ignore_area_enter = spirit_player
	get_parent().add_child(spirit_player)
	spirit_player.position = position
	spirit_player.player = self
	can_summon_spirit = false
	world.spirit_form_start(self)
	spirit_player.get_node("MoveCollection").input = $MoveCollection.input
	EMITTER.emit('player_spirit_form_start', self)

func spirit_form_end(spirit):
	position = spirit.position
	$MoveCollection.time_multiplier = 1
	modulate = Color(1, 1, 1, 1)
	$CollisionShape2D.disabled = false
	var move_collection = $MoveCollection
	move_collection.stop_movement("GravityMovement")
	move_collection.stop_movement("JumpMovement")
	move_collection.stop_movement("WallJumpMovement")
	var movement = move_collection.add_follow_through_movement()
	movement.strength = 550
	movement.strength_decay = 100
	can_summon_spirit = false
	world.spirit_form_end(self)
	level_transition_indicator.global_position = global_position
	
	movement.direction = spirit_player.get_node('MoveCollection').velocity
	spirit_player = null

func _physics_process(delta):
	check_near_walls()
	
	if !on_floor and is_on_floor():
		just_landed()
	on_floor = is_on_floor()
	
	if !on_wall and is_on_wall():
		just_hit_wall()
	on_wall = is_on_wall()
	
	if spirit_player == null and (is_on_floor() or near_wall != null) and $WindUpAnimationTimer.time_left == 0:
		can_summon_spirit = true
	
	var input = $MoveCollection.input
	if signature_action_enabled and can_summon_spirit and input.action_just_pressed_counter < 0.15:
		input.action_just_pressed_counter = INF
		spirit_form_wind_up()
	
	if spirit_player != null:
		level_transition_indicator.global_position = spirit_player.global_position
	else:
		level_transition_indicator.global_position = global_position
	
	emit_movement_heartbeat(delta)
	handle_visuals()

func check_near_walls():
	near_wall = null
	for body in $WallCheckArea.get_overlapping_bodies():
		if body.is_in_group("wall_jump_platform"):
			near_wall = body

func emit_movement_heartbeat(delta):
	if horizontal_movement.direction == 0 \
		or (on_wall and on_floor) \
		or spirit_player != null:
		movement_heartbeat_counter = 0
	else:
		movement_heartbeat_counter += delta
		if movement_heartbeat_counter > movement_heartbeat_interval:
			movement_heartbeat_counter = 0
			EMITTER.emit('player_movement_heartbeat', self)

func handle_visuals():
	var visual_scale = $Visuals.scale
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

func randomize_footstep_sound():
	$FootstepsAudio.pitch_scale = 0.9 + randf() * 0.3
	$FootstepsAudio.volume_db = -2 * randf() - 10

func just_landed():
	$FallLandingAudio.pitch_scale = 0.8 + randf() * 0.4
	$FallLandingAudio.play()

func just_hit_wall():
	if !on_floor:
		pass
#		$FallLandingAudio.pitch_scale = 0.8 + randf() * 0.4
#		$FallLandingAudio.play()

func on_jump():
	$JumpAudio.pitch_scale = 0.8 + randf() * 0.4
	$JumpAudio.play()

func on_wall_jump():
	$JumpAudio.pitch_scale = 0.8 + randf() * 0.4
	$JumpAudio.play()

func get_dialog_target():
	return $Visuals/Sprites/torso
