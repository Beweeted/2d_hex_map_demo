extends TileMap
class_name MyTileMap

func _input(_InputEvent) -> void:
	#print_mouse_click_location(_InputEvent)
	pass


func print_mouse_click_location(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var local_mouse_location = to_local(get_global_mouse_position())
		print("Click: %s, Coords: %s" % [get_global_mouse_position(), world_to_map(local_mouse_location)])
		print(cell_custom_transform)


func translated_map_to_world(map_position: Vector2, ignore_half_ofs: bool = false) -> Vector2:
	var world_position = map_to_world(map_position, ignore_half_ofs)
	world_position.x += cell_size.x/2
	world_position.y += cell_size.y/2
	return world_position


func translated_world_to_map(world_position: Vector2) -> Vector2:
	world_position.x -= cell_size.x/2
	world_position.y -= cell_size.y/2
	var map_position = world_to_map(world_position)
	return map_position


func get_map_tile(coords: Vector2, from_world: bool = false) -> Tile:
	if from_world:
		coords = translated_world_to_map(coords)
	return Tile.new(coords, translated_map_to_world(coords), get_cellv(coords))
