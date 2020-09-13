extends Node2D


func _ready():
	print(OS.window_size)
	var platforms = get_node_or_null("Platforms")
	if platforms != null:
		for platform in platforms.get_children():
			draw_platform_in_tilemap(platform)
		$TileMap.update_bitmask_region()


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
			$TileMap.set_cell(map_pos.x, map_pos.y, 0)
			current_x += $TileMap.cell_size.x
		current_y += $TileMap.cell_size.y
