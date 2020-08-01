extends Node2D


var velocity = Vector2(0, 0)
var target
var is_on_floor = true
var is_dashing = false
var is_charging_dash = false

func _ready():
	target = get_parent()

func _physics_process(_delta):
	update()
	
	var updated_velocity = Vector2(0, 0)
	for child in get_children():
		if child.has_method("get_velocity"):
			updated_velocity += child.get_velocity(self)
	
	velocity = updated_velocity
	target.move_and_slide(velocity, Vector2(0, -1))

func update():
	is_on_floor = target.is_on_floor()
