extends Area2D

signal player_entered

var is_active = false

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	is_active = true
	emit_signal("player_entered", self, body)
