extends Node2D

func _ready():
	$LevelOrigin.connect("level_active", self, "on_level_active")

func on_level_active():
	$LevelOrigin.world.play_main_loop()
