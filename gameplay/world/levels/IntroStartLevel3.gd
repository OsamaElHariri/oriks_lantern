extends Node2D

func _ready():
	$LevelOrigin.connect("level_active", self, "on_level_active")

func on_level_active():
	var player = $LevelOrigin.world.player
	player.position.x -= 700
	
	var level = $LevelOrigin.world.get_node_or_null("Levels/IntroStartLevel2")
	if level:
		var width = level.get_node("LevelOrigin").level_width
		for child in $LevelOrigin.world.get_node("Levels").get_children():
			if name == child.name: continue
			child.position.x -= width
			child.position.y -= 16 * 31
		level.queue_free()
		
