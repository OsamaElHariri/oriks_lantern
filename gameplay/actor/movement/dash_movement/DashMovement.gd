extends Node2D

signal player_dash_init
signal player_dash_start

export var strength = 3000
export var duration = 6
export var charge_duration = 10

export var fade_away_strength = 500
export var fade_away_strength_decay = 100

var has_dash = true
var direction = Vector2(1, -1)
var dash_time = INF
var charge_time = INF

var current_fade_away_strength = 0

func get_velocity(move_collection):
	if move_collection.is_on_floor and !move_collection.is_dashing:
		has_dash = true
		dash_time = INF
		current_fade_away_strength = 0
	
	if has_dash and move_collection.dash_just_pressed:
		move_collection.is_charging_dash = true
		charge_time = 0
		move_collection.on_player_dash_init()
	
	var force_dash = move_collection.is_charging_dash and charge_time > charge_duration
	
	if has_dash:
		if move_collection.dash_just_released:
			short_circuit_dash(move_collection)
		elif force_dash:
			trigger_dash(move_collection)
	
	if move_collection.is_charging_dash:
		charge_time += 1
		return Vector2(0, 0)
	
	if duration > dash_time:
		dash_time += 1 * move_collection.time_multiplier
		return direction * strength * move_collection.time_multiplier
	
	move_collection.is_dashing = false
	current_fade_away_strength = max(current_fade_away_strength - fade_away_strength_decay, 0)
	
	return direction * current_fade_away_strength

func trigger_dash(move_collection):
	charge_time = INF
	move_collection.is_charging_dash = false
	var dash_direction = get_direction(move_collection)
	move_collection.on_player_dash_start()
	if !move_collection.is_on_floor or dash_direction.y <= 0:
		move_collection.is_dashing = true
		has_dash = false
		direction = dash_direction
		current_fade_away_strength = fade_away_strength
		dash_time = 0

func short_circuit_dash(move_collection):
	charge_time = INF
	move_collection.is_charging_dash = false
	move_collection.on_player_dash_short_circuit()

func get_direction(move_collection):
	var horizontal = 0
	if move_collection.left_pressed:
		horizontal = -1
	elif move_collection.right_pressed:
		horizontal = 1
		
	var vertical = 0
	if move_collection.up_pressed:
		vertical = -1
	elif move_collection.down_pressed:
		vertical = 1
	
	if horizontal == 0 and vertical == 0:
		vertical = -1
	
	return Vector2(horizontal, vertical).normalized()
