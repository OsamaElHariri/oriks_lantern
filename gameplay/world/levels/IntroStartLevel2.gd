extends Node2D

var world_camera
var initial_robot_pos

func _ready():
	$Robot.visible = false
	initial_robot_pos = $Robot/CrusherRobot.position
	$LevelOrigin.connect("level_active", self, "on_level_active")
	$LevelOrigin.connect("level_inactive", self, "on_level_inactive")
	world_camera = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera")

func on_level_active():
	$Robot.visible = true
	var background = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera/ParallaxBackground/ParallaxLayer/background")
	if background:
		background.modulate = Color(0.09, 0.06, 0.91)

func on_level_inactive():
	$Robot.visible = false
	var background = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera/ParallaxBackground/ParallaxLayer/background")
	if background:
		background.modulate = Color(1, 1, 1)

func _physics_process(_delta):
	if world_camera:
		$Robot/CrusherRobot.global_position.x = -get_viewport_transform().get_origin().x + OS.get_screen_size().x
#		$Robot/CrusherRobot.global_position.x = world_camera.global_position.x + OS.get_screen_size().x / 2

