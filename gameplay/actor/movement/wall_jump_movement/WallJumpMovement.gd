extends Node2D

export var x_strength = 1600
export var y_strength = 2100
export var x_strength_decay = 200
export var y_strength_decay = 50

var current_strength = Vector2.ZERO

var x_direction = 0

var horizontal_movment = null

func _ready():
	horizontal_movment = get_parent().get_node_or_null("HorizontalMovement")

func get_velocity(move_collection):
	var resisting_push = resisting_wall_push(move_collection)
	var decay = Vector2(x_strength_decay, y_strength_decay) * move_collection.time_multiplier
	current_strength = Vector2(max(current_strength.x - decay.x, 0), max(current_strength.y - decay.y, 0))
	
	if move_collection.is_on_floor or move_collection.is_on_wall:
		stop()
	
	if !move_collection.is_on_floor and move_collection.target.near_wall != null && move_collection.jump_just_pressed:
		x_direction = sign(move_collection.target.global_position.x - move_collection.target.near_wall.global_position.x)
		var x_current_strength = x_strength
		
		current_strength = Vector2(x_current_strength, y_strength)
		move_collection.reset_gravity()

	if move_collection.is_dashing or move_collection.is_charging_dash:
		stop()
	
	var augmented_current_strength = current_strength
	if horizontal_movment != null and resisting_push and current_strength.x > 1400:
		augmented_current_strength = Vector2(current_strength.x - horizontal_movment.current_speed * x_direction, current_strength.y)
	
	return Vector2(x_direction, -1) * augmented_current_strength * move_collection.time_multiplier

func stop():
	current_strength = Vector2.ZERO

func resisting_wall_push(move_collection):
	return (x_direction < 0 and move_collection.right_pressed) \
		or (x_direction > 0 and move_collection.left_pressed)

