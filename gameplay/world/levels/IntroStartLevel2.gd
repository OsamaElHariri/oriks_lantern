extends Node2D


func _ready():
	$LevelOrigin.connect("level_active", self, "on_level_active")
	$LevelOrigin.connect("level_inactive", self, "on_level_inactive")

func on_level_active():
	var background = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera/ParallaxBackground/ParallaxLayer/background")
	if background:
		background.modulate = Color(0.09, 0.06, 0.91)

func on_level_inactive():
	var background = $LevelOrigin.world.get_node_or_null("TargetFollower/WorldCamera/ParallaxBackground/ParallaxLayer/background")
	if background:
		background.modulate = Color(1, 1, 1)
