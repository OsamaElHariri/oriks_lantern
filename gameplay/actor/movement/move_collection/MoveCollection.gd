extends Node2D

signal player_dash_init
signal player_dash_start
signal player_dash_short_circuit

var velocity = Vector2(0, 0)
var target
var is_on_floor = true
var is_dashing = false
var is_charging_dash = false
var time_multiplier = 1

var lock_controls = false

var right_pressed = false
var left_pressed = false
var up_pressed = false
var down_pressed = false
var jump_just_pressed = false
var jump_pressed = false
var dash_just_pressed = false
var dash_just_released = false

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
	
	if !lock_controls:
		right_pressed = Input.is_action_pressed("ui_right")
		left_pressed = Input.is_action_pressed("ui_left")
		up_pressed = Input.is_action_pressed("ui_up")
		down_pressed = Input.is_action_pressed("ui_down")
	
	jump_pressed = !lock_controls and Input.is_action_pressed("jump")
	jump_just_pressed = !lock_controls and Input.is_action_just_pressed("jump")
	
	dash_just_pressed = !lock_controls and Input.is_action_just_pressed("dash")
	dash_just_released = !lock_controls and Input.is_action_just_released("dash")

func trigger_dash():
	for child in get_children():
		if child.has_method("trigger_dash"):
			child.trigger_dash(self)

func on_player_dash_init():
	emit_signal("player_dash_init")

func on_player_dash_start():
	emit_signal("player_dash_start")

func on_player_dash_short_circuit():
	emit_signal("player_dash_short_circuit")
