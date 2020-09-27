extends TextureRect


func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Area2D.position.x = rect_size.x / 2
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = Vector2(rect_size.x / 2, $Area2D.position.y)
	$Area2D/CollisionShape2D.shape = rect_shape

func on_body_entered(body):
	if body.is_in_group("player") and body.has_method("trigger_defeat"):
		body.trigger_defeat(self)
