extends Node
class_name BoardManager

onready var tilemap = $TileMap
onready var troll = $TileMap/Troll


func _ready() -> void:
	troll.reset_tile(tilemap)


func _input(_InputEvent: InputEvent) -> void:
	if not troll.is_animating():
		var input := get_input_vector(_InputEvent)
		var hex_motion := input_to_hex_motion(input)
		if hex_motion != Vector2.ZERO:
			var target_tile = tilemap.get_map_tile(troll.my_tile.coords + hex_motion)
			troll.move_to_hex(target_tile)


func get_input_vector(_Input: InputEvent) -> Vector2:
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if motion != Vector2.ZERO:
		return motion
	return Vector2.ZERO


func input_to_hex_motion(input_vec: Vector2) -> Vector2:
	var motion = Vector2()
	if input_vec.x > 0:
		motion.x = 1
	if input_vec.x < 0:
		motion.x = -1
	if input_vec.y > 0:
		motion.y = 1
	if input_vec.y < 0:
		motion.y = -1

	# Not moving
	if input_vec == Vector2.ZERO:
		return Vector2.ZERO
	# Can't move sideways
	if motion.x != 0 and motion.y == 0:
		return Vector2.ZERO

	# Moving on diagonal
	if motion.x != 0 and motion.y != 0:
		motion.y = min(motion.y, 0) if int(troll.my_tile.coords.x) % 2 == 0 else max(motion.y, 0)
	return motion
