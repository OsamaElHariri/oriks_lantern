extends Sprite


export var spawn_top_decor = true

func adjust_textures():
	var offset = Vector2(16 * randi() % 100, 16 * randi() % 100)
	$PlatformTexture.scale = Vector2.ONE / scale
	var texture_size = texture.get_size()
	$PlatformTexture.region_rect = Rect2(
		offset.x,
		offset.y,
		texture_size.x * scale.x - 24,
		texture_size.y * scale.y - 24
	)
	texture = null
