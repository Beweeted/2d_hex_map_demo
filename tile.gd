var coords: Vector2
var position: Vector2
var _tile_type: int

var swamp_tiles: PoolIntArray = [10, 11, 18, 19, 20]
var forest_tiles: PoolIntArray = [6, 7, 8, 9, 16]
var rocky_tiles: PoolIntArray = [15, 22, 24]
var building_tiles: PoolIntArray = [9, 12, 14, 20] #unused
var obstruction_tiles: PoolIntArray = [-1, 25]

class_name Tile

func _init(initial_coords: Vector2, initial_position: Vector2, tile_type: int = -1) -> void:
	self.coords = initial_coords
	self.position = initial_position
	self._tile_type = tile_type


func _to_string() -> String:
	return "Coord: %s, Pos: %s, Type: %s" % [coords, position, _tile_type]

func is_moveable() -> bool:
	return not (_tile_type in obstruction_tiles or _tile_type in building_tiles)


func is_slow() -> bool:
	return (_tile_type in swamp_tiles or _tile_type in forest_tiles or _tile_type in rocky_tiles)


func print() -> void:
	print("Coord: %s, Pos: %s, Type: %s" % [coords, position, _tile_type])


