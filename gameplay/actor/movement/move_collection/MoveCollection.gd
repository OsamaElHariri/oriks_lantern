extends Node2D

const FOLLOW_THROUGH_MOVEMENT = preload("res://gameplay/actor/movement/follow_through_movement/FollowThroughMovement.tscn")
const PLAYER_INPUT = preload("res://gameplay/actor/movement/move_collection/PlayerInput.gd")

export var should_snap = true

var _movements = {}

var velocity = Vector2(0, 0)
var target
var is_on_ceiling = false
var is_on_floor = true
var is_on_wall = false
var time_multiplier = 1

var on_floor_counter = INF

var input = null

func _ready():
	input = PLAYER_INPUT.new()
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

func _physics_process(delta):
	state_update(delta)
	
	var updated_velocity = Vector2(0, 0)
	for child in get_children():
		if child.has_method("get_velocity"):
			updated_velocity += child.get_velocity(self)
	
	velocity = updated_velocity
	
	var snap = Vector2.DOWN * 8 if !input.jump_just_pressed and should_snap else Vector2.ZERO
	target.move_and_slide_with_snap(velocity, snap, Vector2(0, -1))

func state_update(delta):
	input_update(delta)
	on_floor_counter += delta
	
	if is_on_floor:
		on_floor_counter = 0

func input_update(delta):
	is_on_floor = target.is_on_floor()
	is_on_wall = target.is_on_wall()
	is_on_ceiling = target.is_on_ceiling()
	input.update(delta)
