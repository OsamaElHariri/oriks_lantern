extends Camera2D

var is_narrowing = false

func _ready():
	EMITTER.connect("player_dash_init", self, "on_player_dash_init")
	EMITTER.connect("player_dash_start", self, "on_player_dash_start")

func on_player_dash_init(_player):
	is_narrowing = true

func on_player_dash_start(_player):
	is_narrowing = false

func _physics_process(_delta):
	if is_narrowing:
		zoom = zoom - (zoom - Vector2(0.97, 0.97)) * 0.2
	else:
		zoom = zoom - (zoom - Vector2(1, 1)) * 0.6
