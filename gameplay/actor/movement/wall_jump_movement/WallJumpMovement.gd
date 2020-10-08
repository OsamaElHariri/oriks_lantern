extends Node2D

export var x_strength = 1050
export var y_strength = 1600
export var x_strength_decay = 170
export var y_strength_decay = 55

var current_strength = Vector2.ZERO

var x_direction = 0

var horizontal_movment = null

func init_movement(move_collection):
	horizontal_movment = move_collection.get_movement("HorizontalMovement")

func get_velocity(move_collection):
	var resisting_push = resisting_wall_push(move_collection)
	var decay = Vector2(x_strength_decay, y_strength_decay) * move_collection.time_multiplier
	if move_collection.is_on_ceiling:
		decay *= 3
	current_strength = Vector2(max(current_strength.x - decay.x, 0), max(current_strength.y - decay.y, 0))
	
	if move_collection.is_on_floor or move_collection.is_on_wall:
		stop()
	
	if !move_collection.is_on_floor and move_collection.target.near_wall != null && move_collection.jump_just_pressed_counter < 0.1:
		move_collection.jump_just_pressed_counter = INF
		x_direction = sign(move_collection.target.global_position.x - move_collection.target.near_wall.global_position.x)
		var x_current_strength = x_strength
		
		current_strength = Vector2(x_current_strength, y_strength)
		move_collection.stop_movement("GravityMovement")
		
		if move_collection.target.has_method('on_wall_jump'):
			move_collection.target.on_wall_jump()
	
	var augmented_current_strength = current_strength
	if horizontal_movment != null and resisting_push and current_strength.x > current_strength.x * 0.95:
		augmented_current_strength = Vector2(current_strength.x - horizontal_movment.current_speed * x_direction, current_strength.y)
	
	return Vector2(x_direction, -1) * augmented_current_strength * move_collection.time_multiplier

func stop():
	current_strength = Vector2.ZERO

func resisting_wall_push(move_collection):
	return (x_direction < 0 and move_collection.right_pressed) \
		or (x_direction > 0 and move_collection.left_pressed)

