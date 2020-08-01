extends Node2D

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
	
	if has_dash and Input.is_action_just_pressed("dash"):
		move_collection.is_charging_dash = true
		charge_time = 0
		EMITTER.emit("player_dash_init")
	
	var force_dash = move_collection.is_charging_dash and charge_time > charge_duration
		
	if has_dash and (force_dash or Input.is_action_just_released("dash")):
		var dash_direction = get_direction()
		charge_time = INF
		move_collection.is_charging_dash = false
		EMITTER.emit("player_dash_start")
		if !move_collection.is_on_floor or dash_direction.y <= 0:
			move_collection.is_dashing = true
			has_dash = false
			direction = dash_direction
			current_fade_away_strength = fade_away_strength
			dash_time = 0
	
	if move_collection.is_charging_dash:
		charge_time += 1
		return Vector2(0, 0)
	
	if duration > dash_time:
		dash_time += 1
		return direction * strength
	
	move_collection.is_dashing = false
	current_fade_away_strength = max(current_fade_away_strength - fade_away_strength_decay, 0)
	
	return direction * current_fade_away_strength

func get_direction():
	var horizontal = 0
	if Input.is_action_pressed("ui_left"):
		horizontal = -1
	elif Input.is_action_pressed("ui_right"):
		horizontal = 1
		
	var vertical = 0
	if Input.is_action_pressed("ui_up"):
		vertical = -1
	elif Input.is_action_pressed("ui_down"):
		vertical = 1
	
	if horizontal == 0 and vertical == 0:
		vertical = -1
	
	return Vector2(horizontal, vertical).normalized()
