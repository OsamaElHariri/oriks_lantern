extends Camera2D

var is_narrowing = false
var previous_position = Vector2.ZERO
var velocity = Vector2.ZERO


onready var noise = OpenSimplexNoise.new()
var noise_y = 0
var max_shake_offset = Vector2(150, 50)
var shake_intensity = 0

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 1
	noise.octaves = 5
	EMITTER.connect("request_screen_shake", self, "on_request_screen_shake")

func on_request_screen_shake(duration):
	shake_intensity = duration

func _process(delta):
	shake_intensity = max(0, shake_intensity - delta)
	noise_y += 1
	offset.x = max_shake_offset.x * shake_intensity * noise.get_noise_2d(noise.seed * 2, noise_y)
	offset.y = max_shake_offset.y * shake_intensity * noise.get_noise_2d(noise.seed * 3, noise_y)

func _physics_process(_delta):
	if is_narrowing:
		zoom = zoom - (zoom - Vector2(0.985, 0.985)) * 0.2
	else:
		zoom = zoom - (zoom - Vector2(1, 1)) * 0.6
	
	var canvas_pos = get_viewport_transform().get_origin()
	velocity = previous_position - canvas_pos
	previous_position = canvas_pos
