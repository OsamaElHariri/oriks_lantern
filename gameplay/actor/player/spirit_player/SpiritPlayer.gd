extends KinematicBody2D


func _ready():
	$MoveCollection.update()
	$MoveCollection.trigger_dash()

