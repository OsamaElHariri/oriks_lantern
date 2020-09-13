extends Area2D

export var speed = 300
export var ramp_up_speed = 30

var current_speed = 0
var active = false

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group("player"):
		active = true

func _physics_process(_delta):
	if active:
		current_speed = min(speed, current_speed + ramp_up_speed)
		$KinematicBody2D.move_and_slide(Vector2.DOWN * current_speed, Vector2.UP)
