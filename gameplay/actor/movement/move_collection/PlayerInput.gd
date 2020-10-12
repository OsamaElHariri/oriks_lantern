extends Node

var right_pressed = false
var left_pressed = false
var up_pressed = false
var down_pressed = false
var right_just_pressed = false
var left_just_pressed = false
var jump_just_pressed = false
var jump_pressed = false
var action_just_pressed = false

var left_just_pressed_time = 0
var right_just_pressed_time = 0

var jump_just_pressed_counter = INF
var action_just_pressed_counter = INF

func update(delta):
	right_pressed = Input.is_action_pressed("ui_right")
	left_pressed = Input.is_action_pressed("ui_left")
	up_pressed = Input.is_action_pressed("ui_up")
	down_pressed = Input.is_action_pressed("ui_down")
	
	right_just_pressed = Input.is_action_just_pressed("ui_right")
	left_just_pressed = Input.is_action_just_pressed("ui_left")
	
	jump_pressed = Input.is_action_pressed("jump")
	jump_just_pressed = Input.is_action_just_pressed("jump")
	
	if left_just_pressed:
		left_just_pressed_time = OS.get_system_time_msecs()
	
	if right_just_pressed:
		right_just_pressed_time = OS.get_system_time_msecs()
	
	jump_just_pressed_counter += delta
	if jump_just_pressed:
		jump_just_pressed_counter = 0
	
	action_just_pressed = Input.is_action_just_pressed("signature_action")
	action_just_pressed_counter += delta
	if action_just_pressed:
		action_just_pressed_counter = 0
