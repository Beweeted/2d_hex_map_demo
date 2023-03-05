class_name BoardManager extends Node

onready var tilemap = $TileMap
onready var troll = $TileMap/Troll

var is_animating: bool

func _ready() -> void:
	troll.reset_tile(tilemap)
	is_animating = false


func _input(_InputEvent: InputEvent) -> void:
	if not is_animating:
		var input := get_input_vector(_InputEvent)
		var hex_motion := input_to_hex_motion(input)
		if hex_motion != Vector2.ZERO:
			var target_tile = tilemap.get_map_tile(troll.my_tile.coords + hex_motion)
			is_animating = troll.try_moving(target_tile)
			if is_animating:
				troll.connect("finished_moving", self, "on_Unit_finished_moving")


func on_Unit_finished_moving() -> void:
	is_animating = false


func get_input_vector(event: InputEvent) -> Vector2:
	var motion = Vector2()
	if event is InputEventMouseButton:
		tilemap.print_mouse_click_location(event)
		#get mouse coords
		#if clicked tile is adjacent
			#motion = towards clicked tile
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up"):
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
