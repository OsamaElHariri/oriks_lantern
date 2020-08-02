extends KinematicBody2D


func _ready():
	$MoveCollection.update()
	$MoveCollection/DashMovement.trigger_dash($MoveCollection)
	$MoveCollection.connect("player_dash_init", self, "on_player_dash_init")

func on_player_dash_init():
	$DashWindUpAnimationPlayer.play("DashWindUp")
