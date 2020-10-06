extends Area2D


func _ready():
	connect("area_entered", self, "on_area_entered")
	connect("area_exited", self, "on_area_exited")

func on_area_entered(_player):
	EMITTER.emit("player_entered_level", get_parent().get_parent())

func on_area_exited(_player):
	EMITTER.emit("player_exited_level", get_parent().get_parent())
