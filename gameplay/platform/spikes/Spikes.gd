extends TextureRect

var smoke_offset = 0
var smoke_offset_2 = 0

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Area2D.position.x = rect_size.x / 2
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = Vector2(rect_size.x / 2, $Area2D.position.y)
	$Visuals/DangerMushroomSmoke.region_rect = Rect2(0, 0, rect_size.x, 64)
	$Visuals/DangerMushroomSmoke.position.x = rect_size.x / 2
	$Visuals/DangerMushroomSmoke2.region_rect = Rect2(0, 0, rect_size.x, 64)
	$Visuals/DangerMushroomSmoke2.position.x = rect_size.x / 2
	$Area2D/CollisionShape2D.shape = rect_shape

func on_body_entered(body):
	if body.is_in_group("player") and body.has_method("trigger_defeat"):
		body.trigger_defeat(self)

func _process(delta):
	smoke_offset += delta * 50
	if smoke_offset > 96: smoke_offset = 0
	smoke_offset_2 += delta * 25
	if smoke_offset_2 > 96: smoke_offset_2 = 0
	$Visuals/DangerMushroomSmoke.region_rect = Rect2(smoke_offset, 0, rect_size.x, 64)
	$Visuals/DangerMushroomSmoke2.region_rect = Rect2(-smoke_offset_2, 0, rect_size.x, 64)
