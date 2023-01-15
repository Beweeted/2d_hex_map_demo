extends TileMap
class_name MyTileMap


#Deprecated, use overloaded map_to_world instead. Callers don't need to know that we're doing anything unusual.
func translated_map_to_world(map_position: Vector2, ignore_half_ofs: bool = false) -> Vector2:
	return map_to_world(map_position, ignore_half_ofs)


#Deprecated, use overloaded world_to_map instead. Callers don't need to know that we're doing anything unusual.
func translated_world_to_map(world_position: Vector2) -> Vector2:
	return world_to_map(world_position)


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
