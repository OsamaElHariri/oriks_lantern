extends Node2D

var active_levels = []
var player = null

func _ready():
	player = get_node_or_null("Player")
	$TargetFollower.target = player
	EMITTER.connect("player_dash_start", self, "on_player_dash_start")
	EMITTER.connect("spirit_journey_end", self, "on_spirit_journey_end")
	EMITTER.connect("player_entered_level", self, "on_player_entered_level")
	EMITTER.connect("player_exited_level", self, "on_player_exited_level")

func on_player_dash_start(_player):
	$TargetFollower.target = player.spirit_player

func on_spirit_journey_end(_player):
	$TargetFollower.target = player

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
