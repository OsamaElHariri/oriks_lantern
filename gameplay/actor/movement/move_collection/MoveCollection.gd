extends Node2D

signal player_dash_init
signal player_dash_start
signal player_dash_short_circuit

const FOLLOW_THROUGH_MOVEMENT = preload("res://gameplay/actor/movement/follow_through_movement/FollowThroughMovement.tscn")

export var should_snap = true

var _movements = {}

var velocity = Vector2(0, 0)
var target
var is_on_floor = true
var is_on_wall = false
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
	for child in get_children():
		_movements[child.name] = child
		if child.has_method("init_movement"):
			child.init_movement(self)

func get_movement(movement_name):
	if _movements.has(movement_name):
		return _movements[movement_name]
	return null

func stop_movement(movement_name):
	var movement = get_movement(movement_name)
	if movement and movement.has_method("stop"):
		movement.stop()

func add_follow_through_movement():
	var movement = FOLLOW_THROUGH_MOVEMENT.instance()
	add_child(movement)
	return movement

func _physics_process(_delta):
	update()
	
	var updated_velocity = Vector2(0, 0)
	for child in get_children():
		if child.has_method("get_velocity"):
			updated_velocity += child.get_velocity(self)
	
	velocity = updated_velocity
	
	var snap = Vector2.DOWN * 32 if !jump_just_pressed and should_snap else Vector2.ZERO
	target.move_and_slide_with_snap(velocity, snap, Vector2(0, -1))

func update():
	is_on_floor = target.is_on_floor()
	is_on_wall = target.is_on_wall()
	
	if !lock_controls:
		right_pressed = Input.is_action_pressed("ui_right")
		left_pressed = Input.is_action_pressed("ui_left")
		up_pressed = Input.is_action_pressed("ui_up")
		down_pressed = Input.is_action_pressed("ui_down")
	else:
		right_pressed = false
		left_pressed = false
		up_pressed = false
		down_pressed = false
	
	jump_pressed = !lock_controls and Input.is_action_pressed("jump")
	jump_just_pressed = !lock_controls and Input.is_action_just_pressed("jump")
	
	dash_just_pressed = !lock_controls and Input.is_action_just_pressed("dash")
	dash_just_released = !lock_controls and Input.is_action_just_released("dash")

func on_player_dash_init():
	emit_signal("player_dash_init")

func on_player_dash_start():
	emit_signal("player_dash_start")

func on_player_dash_short_circuit():
	emit_signal("player_dash_short_circuit")
