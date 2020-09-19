extends Area2D


func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(_player):
	EMITTER.emit("player_entered_level", get_parent().get_parent())

func on_body_exited(_player):
	EMITTER.emit("player_exited_level", get_parent().get_parent())
