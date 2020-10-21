extends Sprite

var LEVEL_AREA = preload("res://gameplay/world/level_origin/LevelArea.tscn")

func _ready():
	var level_area = LEVEL_AREA.instance()
	var shape = RectangleShape2D.new()
	shape.extents = scale * 2
	level_area.get_node("CollisionShape2D").set_shape(shape)
	level_area.position = position
	var parent = get_parent()
	parent.call_deferred("add_child", level_area)
	
	if 'level_width' in parent:
		parent.level_width = texture.get_size().x * scale.x
	
	if 'level_height' in parent:
		parent.level_height = texture.get_size().y * scale.y
	
	queue_free()

