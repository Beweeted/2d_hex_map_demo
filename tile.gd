class_name Tile

const Terrain = preload("res://terrain.gd")

var coords: Vector2
var position: Vector2
var _tile_type_id: int
var _terrain: Terrain


func _init(initial_coords: Vector2, initial_position: Vector2, tile_type_id: int = -1) -> void:
	self.coords = initial_coords
	self.position = initial_position
	self._tile_type_id = tile_type_id
	self._terrain = Terrain.new(tile_type_id)


func _to_string() -> String:
	return "Coord: %s, Pos: %s, Type: %s" % [coords, position, _tile_type_id]


func get_terrain_type() -> int:
	return _terrain.type


func print() -> void:
	print("Coord: %s, Pos: %s, Type: %s" % [coords, position, _tile_type_id])


