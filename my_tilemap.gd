class_name MyTileMap extends TileMap

func map_to_world(map_position: Vector2, ignore_half_ofs: bool = false) -> Vector2:
	var world_position = .map_to_world(map_position, ignore_half_ofs)
	world_position.x += cell_size.x/2
	world_position.y += cell_size.y/2
	return world_position


func world_to_map(world_position: Vector2) -> Vector2:
	world_position.x -= cell_size.x/2
	world_position.y -= cell_size.y/2
	var map_position = .world_to_map(world_position)
	return map_position


#Used to get the Tile instead of just the coordinates.
func get_map_tile(coords: Vector2, engine_position: bool = false) -> Tile:
	if engine_position:
		coords = world_to_map(coords)
	print("Getting tile: %s, cellv: %s, engine_position: %s" % [coords, get_cellv(coords), engine_position])
	return Tile.new(coords, map_to_world(coords), get_cellv(coords))


func print_mouse_click_location(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var local_mouse_location = to_local(get_global_mouse_position())
		print("Click: %s, Coords: %s" % [get_global_mouse_position(), world_to_map(local_mouse_location)])
		""" TODO: Something in here is sliding weird. This is a vertical column, but both axis are wiggling:
		Click: (-175, 77.5), Coords: (2, -2)
		Click: (-167, 13.5), Coords: (3, -3)
		Click: (-179, -92.5), Coords: (2, -4)
		Click: (-183, -23.5), Coords: (2, -3)
		Click: (-183, 50.5), Coords: (2, -2)
		"""

