extends Node

var right_pressed = false
var left_pressed = false
var up_pressed = false
var down_pressed = false
var right_just_pressed = false
var left_just_pressed = false
var jump_just_pressed = false
var jump_pressed = false
var action_pressed = false
var action_just_pressed = false

var left_just_pressed_time = 0
var right_just_pressed_time = 0

var jump_just_pressed_counter = INF
var action_just_pressed_counter = INF


var started = false
var scripted_time = 0
var scene_name

func start(scene):
	scene_name = scene
	started = true

func update(delta):
	if not started: return
	
	scripted_time += delta
	if scene_name == 'explanation':
		explanation_scene()
	elif scene_name == 'escape':
		escape_scene()

func explanation_scene():
	if between(0, 1.6):
		left_just_pressed = true
		left_pressed = true
	else:
		left_pressed = false
		left_just_pressed = false
	
	if between(1.6, 1.8):
		right_just_pressed = true
		right_pressed = true
	else:
		right_pressed = false
		right_just_pressed = false
	
	if between(0.5, 1.4):
		jump_just_pressed = true
		jump_just_pressed_counter = 0
	else:
		jump_just_pressed = false
		jump_just_pressed_counter = INF

func escape_scene():
	up_pressed = true
	if between(1.5, 9):
		left_just_pressed = true
		left_pressed = true
	else:
		left_pressed = false
		left_just_pressed = false
	
	if between(0, 0.3):
		right_just_pressed = true
		right_pressed = true
	else:
		right_pressed = false
		right_just_pressed = false
	
	if between(1, 2.4):
		action_just_pressed = true
		action_pressed = true
		action_just_pressed_counter = 0
	else:
		action_pressed = false
		action_just_pressed = false
		action_just_pressed_counter = INF
	
	if between(4.85, 5):
		jump_just_pressed = true
		jump_pressed = true
		jump_just_pressed_counter = 0
	else:
		jump_just_pressed = false
		jump_pressed = false
		jump_just_pressed_counter = INF

func between(p1 ,p2):
	return scripted_time >= p1 and scripted_time <= p2
