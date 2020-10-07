extends Area2D

signal player_entered

var is_active = false

func _ready():
	connect("area_entered", self, "on_area_entered")

func on_area_entered(area):
	var player = area.get_parent()
	is_active = true
	emit_signal("player_entered", self, player)
