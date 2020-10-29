extends Node2D

var has_played_tune = false
var is_player_close_to_grave = false

var x_camera_offset_multiplier = 0

func _ready():
	$LevelOrigin.connect("level_active", self, "on_level_active")
	$LevelOrigin.connect("level_inactive", self, "on_level_inactive")
	$Area2D.connect("area_entered", self, "on_area_entered")
	$Area2D.connect("area_exited", self, "on_area_exited")

func on_level_active():
	var player = $LevelOrigin.world.player
	player.position.x -= 700
	
	var level = $LevelOrigin.world.get_node_or_null("Levels/IntroStartLevel2")
	if level:
		$LevelOrigin.world.stop_robot_loop()
		var width = level.get_node("LevelOrigin").level_width
		for child in $LevelOrigin.world.get_node("Levels").get_children():
			if name == child.name: continue
			child.position.x -= width
			child.position.y -= 16 * 31
		level.queue_free()

func on_level_inactive():
	$LevelOrigin.world.play_main_loop()
	$LevelOrigin.world.get_node("TargetFollower").offset = Vector2.ZERO

func on_area_entered(_body):
	is_player_close_to_grave = true
	if (!has_played_tune):
		$AudioStreamPlayer.play()
	has_played_tune = true

func on_area_exited(_body):
	is_player_close_to_grave = false

func _process(delta):
	if $LevelOrigin.is_level_active:
		if is_player_close_to_grave:
			x_camera_offset_multiplier += delta * 0.5
			var x_diff = $Decor/grave.global_position.x - $LevelOrigin.world.player.global_position.x
			$LevelOrigin.world.get_node("TargetFollower").offset = Vector2(x_diff / 2 * x_camera_offset_multiplier, 0)
		else:
			x_camera_offset_multiplier -= delta * 2
			$LevelOrigin.world.get_node("TargetFollower").offset = Vector2.ZERO
		x_camera_offset_multiplier = clamp(x_camera_offset_multiplier, 0, 1)
