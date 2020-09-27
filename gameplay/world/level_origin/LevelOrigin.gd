extends Node2D

var glow = preload("res://gameplay/world/level_origin/glow.png")

var grass = [
	preload("res://gameplay/world/level_origin/grass1.png"),
	preload("res://gameplay/world/level_origin/grass2.png"),
	preload("res://gameplay/world/level_origin/grass3.png"),
]

var plants = [
	preload("res://gameplay/world/level_origin/plant1.png"),
	preload("res://gameplay/world/level_origin/plant2.png"),
]

var mushroom = [
	preload("res://gameplay/world/level_origin/mushroom1.png"),
	preload("res://gameplay/world/level_origin/mushroom2.png"),
]
var top_cell_coords = []

func _ready():
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
				var sprite = spawn_grass()
				sprite.position = $TileMap.map_to_world(pos) + Vector2(0, 2)
			if is_top_cell and randf() < 0.5:
				var sprite = spawn_plant() if randf() < 0.5 else spawn_mushroom()
				sprite.position = $TileMap.map_to_world(pos) + Vector2(0, 2)

func spawn_grass():
	var sprite = Sprite.new()
	sprite.texture = grass[randi() % grass.size()]
	sprite.z_index = 10
	sprite.offset = Vector2(sprite.offset.x, -sprite.texture.get_size().y / 1.95)
	sprite.scale = Vector2(sign(randf() - 0.5), 1.2 - randf() * 0.4)
	sprite.rotation_degrees = 3 - 6 * randf()
	
	var modulate_multiplier = 0.9 - randf() * 0.1
	sprite.modulate = Color(modulate_multiplier, modulate_multiplier, modulate_multiplier, 1)
	add_child(sprite)
	return sprite

func spawn_plant():
	var sprite = Sprite.new()
	sprite.texture = plants[randi() % plants.size()]
	sprite.z_index = 10
	sprite.offset = Vector2(sprite.offset.x, -sprite.texture.get_size().y / 1.95)
	sprite.scale = Vector2(sign(randf() - 0.5), 1.2 - randf() * 0.4)
	sprite.rotation_degrees = 3 - 6 * randf()
	
	var modulate_multiplier = 0.9 - randf() * 0.1
	sprite.modulate = Color(modulate_multiplier, modulate_multiplier, modulate_multiplier, 1)
	add_child(sprite)
	var light = Light2D.new()
	sprite.add_child(light)
	light.texture = glow
	light.color = Color(0.9, 0.2, 0.38, 1)
	light.position = Vector2(0, -sprite.texture.get_size().y)
	light.energy = 1.5
	return sprite

func spawn_mushroom():
	var sprite = Sprite.new()
	sprite.texture = mushroom[randi() % mushroom.size()]
	sprite.z_index = 10
	sprite.offset = Vector2(sprite.offset.x, -sprite.texture.get_size().y / 1.95)
	sprite.scale = Vector2(sign(randf() - 0.5), 1.2 - randf() * 0.4)
	sprite.rotation_degrees = 3 - 6 * randf()
	
	var modulate_multiplier = 0.9 - randf() * 0.1
	sprite.modulate = Color(modulate_multiplier, modulate_multiplier, modulate_multiplier, 1)
	add_child(sprite)
	var light = Light2D.new()
	sprite.add_child(light)
	light.texture = glow
	light.position = Vector2(0, -sprite.texture.get_size().y / 2)
	light.color = Color(0.2, 0.6, 0.53, 1)
	light.energy = 1.2
	return sprite

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
