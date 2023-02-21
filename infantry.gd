class_name Infantry extends "res://unit.gd"

func move_cost(tile: Tile) -> int:
	var move_cost = 1
	var immovable = 9999999
	var terrain_type = tile.get_terrain_type()

	#print("Tile type: %s, Matches grass: %s" % [terrain_type, terrain_type == Terrain.GRASS])

	match terrain_type:
		Terrain.ROAD:
			return move_cost / 2
		Terrain.GRASS, Terrain.FOREST:
			return move_cost
		Terrain.SWAMP, Terrain.BUILDING, Terrain.WATER:
			return move_cost * 2
		_:
			return immovable
