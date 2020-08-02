extends KinematicBody2D


func _ready():
	$MoveCollection.update()
	$MoveCollection/DashMovement.trigger_dash($MoveCollection)

