extends Sprite

var LEVEL_AREA = preload("res://gameplay/world/level_origin/LevelArea.tscn")

func _ready():
	var level_area = LEVEL_AREA.instance()
	var shape = RectangleShape2D.new()
	shape.extents = scale * 2
	level_area.get_node("CollisionShape2D").set_shape(shape)
	level_area.position = position
	get_parent().call_deferred("add_child", level_area)
	queue_free()

