extends Node2D

var post_process = null

var active_levels = []
var player = null


func _ready():
	$TargetFollower/WorldCamera/ParallaxBackground.offset = OS.window_size / 2
	player = $Player
	player.world = self
	post_process = $CanvasLayer/PostProcess
	$TargetFollower.target = player
	EMITTER.connect("player_entered_level", self, "on_player_entered_level")
	EMITTER.connect("player_exited_level", self, "on_player_exited_level")

func spirit_form_wind_up(_current_player):
	$TargetFollower/WorldCamera.is_narrowing = true

func spirit_form_start(current_player):
	$TargetFollower/WorldCamera.is_narrowing = false
	$TargetFollower.target = current_player.spirit_player
	post_process.spirit_form_start(current_player)

func spirit_form_end(current_player):
	$TargetFollower.target = current_player
	post_process.spirit_form_end(current_player)

func on_player_entered_level(level):
	active_levels = remove_active_level(level)
	active_levels.append(level)
	set_camera_limits(active_levels[0])

func on_player_exited_level(level):
	active_levels = remove_active_level(level)
	if !active_levels.empty():
		set_camera_limits(active_levels[0])

func remove_active_level(level):
	var new_active_levels = []
	for active_level in active_levels:
		if level.get_instance_id() != active_level.get_instance_id():
			new_active_levels.append(active_level)
	return new_active_levels

func set_camera_limits(level):
	var area = level.get_node("LevelOrigin/LevelArea/CollisionShape2D")
	var pos = area.global_position
	var extents = area.get_shape().extents
	$TargetFollower/WorldCamera.limit_left = pos.x - extents.x
	$TargetFollower/WorldCamera.limit_top = pos.y - extents.y
	$TargetFollower/WorldCamera.limit_right = pos.x + extents.x
	$TargetFollower/WorldCamera.limit_bottom = pos.y + extents.y
