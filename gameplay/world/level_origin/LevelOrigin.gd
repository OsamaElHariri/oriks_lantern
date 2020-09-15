extends Node2D

var grass = [
	preload("res://gameplay/world/level_origin/grass1.png"),
	preload("res://gameplay/world/level_origin/grass2.png"),
	preload("res://gameplay/world/level_origin/grass3.png"),
]
var top_cell_coords = []

func _ready():
	var platforms = get_node_or_null("Platforms")
	if platforms != null:
		for platform in platforms.get_children():
			draw_platform_in_tilemap(platform)
		$TileMap.update_bitmask_region()
		for pos in top_cell_coords:
			var auto_tile_coord = $TileMap.get_cell_autotile_coord(pos.x, pos.y)
			if (auto_tile_coord == Vector2(1, 0) \
				or auto_tile_coord == Vector2(1, 5)) \
				and randf() < 0.6:
				var sprite = Sprite.new()
				sprite.texture = get_random_texture()
				sprite.position = $TileMap.map_to_world(pos)
				sprite.z_index = 10
				sprite.offset = Vector2(sprite.offset.x, -sprite.texture.get_size().y / 1.95)
				sprite.scale = Vector2(sign(randf() - 0.5), 1.2 - randf() * 0.4)
				sprite.rotation_degrees = 3 - 6 * randf()
				
				var modulate_multiplier = 0.9 - randf() * 0.1
				sprite.modulate = Color(modulate_multiplier, modulate_multiplier, modulate_multiplier, 1)
				add_child(sprite)

func draw_platform_in_tilemap(platform):
	var platform_size = platform.texture.get_size()
	var top_left = platform.position - platform_size * platform.scale / 2
	var bottom_right = platform.position + platform_size * platform.scale / 2
	var current_x = top_left.x
	var current_y = top_left.y
	platform.visible = false
	while current_y < bottom_right.y:
		current_x = top_left.x
		while current_x < bottom_right.x:
			var map_pos = $TileMap.world_to_map(Vector2(current_x, current_y))
			if current_y == top_left.y: top_cell_coords.append(map_pos)
			$TileMap.set_cell(map_pos.x, map_pos.y, 0)
			current_x += $TileMap.cell_size.x
		current_y += $TileMap.cell_size.y

func get_random_texture():
	return grass[randi() % grass.size()]
