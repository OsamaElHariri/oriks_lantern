extends Node2D

var LEAVES_DECOR = preload("res://gameplay/world/level_origin/decor/LeavesDecor.tscn")
var BIG_PLANT_DECOR = preload("res://gameplay/world/level_origin/decor/BigPlantDecor.tscn")
var GRASS_DECOR = preload("res://gameplay/world/level_origin/decor/GrassDecor.tscn")

var top_cell_coords = []

func _ready():
	randomize()
	connect_to_spawn_points()
	var platforms = get_node_or_null("Platforms")
	if platforms != null:
		for platform in platforms.get_children():
			draw_platform_in_tilemap(platform)
		$TileMap.update_bitmask_region()
		for pos in top_cell_coords:
			var auto_tile_coord = $TileMap.get_cell_autotile_coord(pos.x, pos.y)
			var is_top_cell = auto_tile_coord == Vector2(1, 0) or auto_tile_coord == Vector2(1, 5)
			if is_top_cell and randf() < 0.6:
				var sprite = spawn_grass_decor()
				sprite.position = $TileMap.map_to_world(pos)
			if is_top_cell and randf() < 0.4:
				var sprite = spawn_leaves_decor()
				sprite.position = $TileMap.map_to_world(pos)

func spawn_leaves_decor():
	var leaves_decor = LEAVES_DECOR.instance()
	var new_scale = Vector2(1, 1)
	new_scale.x += randf() * 0.2 - 0.4
	new_scale.y += randf() * 0.2 - 0.4
	if randf() < 0.5: new_scale.x *= -1
	leaves_decor.scale = new_scale * 0.8
	add_child(leaves_decor)
	return leaves_decor

func spawn_big_plant_decor():
	var big_plant_decor = BIG_PLANT_DECOR.instance()
	var new_scale = Vector2(1, 1)
	new_scale.x += randf() * 0.1 - 0.2
	new_scale.y += randf() * 0.2 - 0.4
	if randf() < 0.5: new_scale.x *= -1
	big_plant_decor.scale = new_scale * 0.5
	add_child(big_plant_decor)
	return big_plant_decor

func spawn_grass_decor():
	var grass_decor = GRASS_DECOR.instance()
	var new_scale = Vector2(1, 1)
	new_scale.x += randf() * 0.1 - 0.2
	new_scale.y = 0.7 + randf() * -0.2
	if randf() < 0.5: new_scale.x *= -1
	grass_decor.scale = new_scale
	grass_decor.z_index = 10
	add_child(grass_decor)
	return grass_decor

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
			if current_y == top_left.y and platform.spawn_top_decor: top_cell_coords.append(map_pos)
			$TileMap.set_cell(map_pos.x, map_pos.y, 0)
			current_x += $TileMap.cell_size.x
		current_y += $TileMap.cell_size.y

func connect_to_spawn_points():
	var location_nodes = get_node_or_null("SpawnLocations")
	if location_nodes == null: return
	for location in location_nodes.get_children():
		location.connect("player_entered", self, "on_spawn_location_player_enetered")
	
func on_spawn_location_player_enetered(spawn_location, _player):
	var location_nodes = get_node_or_null("SpawnLocations")
	if location_nodes == null: return
	for location in location_nodes.get_children():
		location.is_active = location.get_instance_id() == spawn_location.get_instance_id()

func get_spawn_location():
	var location_nodes = get_node_or_null("SpawnLocations")
	if location_nodes == null: return position
	for location in location_nodes.get_children():
		if location.is_active:
			return location.global_position
	if location_nodes.get_child_count() > 0:
		return get_child(0).position
	return position
