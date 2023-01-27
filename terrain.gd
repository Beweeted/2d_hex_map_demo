class_name Terrain

var type: int

const VOID = -1
const GRASS = 0
const FOREST = 1
const SWAMP = 2
const ROCKY = 3
const BUILDING = 4
const WATER = 5
const OBSTRUCTION = 6
const ROAD = 7

const GRASS_TILES: Array = [0, 1, 2, 3, 4, 5, 13, 17]
const FOREST_TILES: Array = [6, 7, 8, 9, 16]
const SWAMP_TILES: Array = [10, 11, 18, 19, 21]
const ROCKY_TILES: Array = [15, 22, 23, 24]
const BUILDING_TILES: Array = [9, 12, 14, 20]
const WATER_TILES: Array = [25]
const OBSTRUCTION_TILES: Array = [-1]
const ROAD_TILES: Array = []

func _init(tile_id: int) -> void:
	type = VOID
	if tile_id in GRASS_TILES:
		type = GRASS
	if tile_id in FOREST_TILES:
		type = FOREST
	if tile_id in SWAMP_TILES:
		type = SWAMP
	if tile_id in ROCKY_TILES:
		type = ROCKY
	if tile_id in WATER_TILES:
		type = WATER
	if tile_id in OBSTRUCTION_TILES:
		type = OBSTRUCTION
	if tile_id in ROAD_TILES:
		type = ROAD

