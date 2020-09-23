extends Node2D


func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group("player") and body.has_method("trigger_defeat"):
		body.trigger_defeat(self)
