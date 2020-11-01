extends Node2D

const PLAYER_SCENE = preload("res://gameplay/actor/player/player/Player.tscn")

var post_process = null

var active_levels = []
var player = null

var main_loop_volume_direction = -1
var robot_loop_volume_direction = -1
var wildlife_loop_volume_direction = 1

func _ready():
	randomize()
	$MusicLoops/WildlifeAudioStreamPlayer.play()
	var screen_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	$TargetFollower/WorldCamera/ParallaxBackground.offset = screen_size / 2
	player = $Player
	player.world = self
	post_process = $CanvasLayer/PostProcess
	$TargetFollower.target = player.get_node("LevelTransitionIndicator")
	random_seed_spirit_wave_effect()
	EMITTER.connect("player_entered_level", self, "on_player_entered_level")
	EMITTER.connect("player_exited_level", self, "on_player_exited_level")

func get_camera():
	return $TargetFollower/WorldCamera

func play_robot_loop():
	$MusicLoops/RobotCrashAudioStreamPlayer.play()
	$MusicLoops/RobotCrashAudioStreamPlayer.volume_db = 0
	robot_loop_volume_direction = 1

func stop_robot_loop():
	robot_loop_volume_direction = -0.5

func stop_wildlife_loop():
	wildlife_loop_volume_direction = -0.5

func play_main_loop():
	if not $MusicLoops/MainAudioStreamPlayer.playing:
		$MusicLoops/MainAudioStreamPlayer.play()
	main_loop_volume_direction = 0.5

func stop_main_loop():
	$MusicLoops/MainAudioStreamPlayer.stop()
	main_loop_volume_direction = -1

func spirit_form_wind_up(_current_player):
	$TargetFollower/WorldCamera.is_narrowing = true

func spirit_form_start(current_player):
	$TargetFollower/WorldCamera.is_narrowing = false
	post_process.spirit_form_start(current_player)
	set_particles_speed_scale(0.3)

func spirit_form_end(current_player):
	post_process.spirit_form_end(current_player)
	set_particles_speed_scale(1)

func on_player_entered_level(level):
	active_levels = remove_active_level(level)
	active_levels.append(level)
	set_camera_limits(active_levels[0])
	level.get_node("LevelOrigin").level_active()

func on_player_exited_level(level):
	active_levels = remove_active_level(level)
	if !active_levels.empty():
		set_camera_limits(active_levels[0])
	level.get_node("LevelOrigin").level_inactive()

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
	$TargetFollower.limit_left = pos.x - extents.x
	$TargetFollower.limit_top = pos.y - extents.y
	$TargetFollower.limit_right = pos.x + extents.x
	$TargetFollower.limit_bottom = pos.y + extents.y

func random_seed_spirit_wave_effect():
	for effect in $CanvasLayer/SpiritWaveEffects.get_children():
		var unique_material = effect.material.duplicate(true)
		unique_material.set_shader_param("offset_ratio", randf())
		effect.material = unique_material

func player_defeat_and_respawn():
	player.queue_free()
	player = PLAYER_SCENE.instance()
	player.world = self
	call_deferred("add_child", player)
	$TargetFollower.target = player.get_node("LevelTransitionIndicator")
	if active_levels.size() > 0:
		player.position = active_levels[0].get_node("LevelOrigin").get_spawn_location()

func _physics_process(delta):
	var current_a = $CanvasLayer/SpiritWaveEffects.modulate.a
	if player.spirit_player == null:
		current_a -= 5 * delta
	else:
		current_a += 3 * delta
	
	if player.can_summon_spirit:
		$CanvasLayer/PostProcess.grey_direction = -1
		$CanvasLayer/SpiritWaveEffects.modulate.a = clamp(current_a, 0, 0.3)
	else:
		$CanvasLayer/PostProcess.grey_direction = 1
		$CanvasLayer/SpiritWaveEffects.modulate.a = clamp(current_a, 0.15, 0.3)
	
	$MusicLoops/MainAudioStreamPlayer.volume_db = clamp($MusicLoops/MainAudioStreamPlayer.volume_db + main_loop_volume_direction, -80, 0)
	$MusicLoops/WildlifeAudioStreamPlayer.volume_db = clamp($MusicLoops/WildlifeAudioStreamPlayer.volume_db + wildlife_loop_volume_direction, -80, 0)
	$MusicLoops/RobotCrashAudioStreamPlayer.volume_db = clamp($MusicLoops/RobotCrashAudioStreamPlayer.volume_db + robot_loop_volume_direction, -80, 0)

func set_particles_speed_scale(speed_scale):
	for child in $TargetFollower/WorldCamera/ParallaxBackground.get_children():
		child.get_node("Particles2D").speed_scale = speed_scale
	
	for child in $TargetFollower/WorldCamera/ParallaxBackground2.get_children():
		child.get_node("Particles2D").speed_scale = speed_scale
