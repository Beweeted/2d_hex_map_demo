extends KinematicBody2D

enum HexDirection {STOPPED = -1, UP, UP_RIGHT, DOWN_RIGHT, DOWN, DOWN_LEFT, UP_LEFT}
enum BumpState {STOPPED, FORWARD, BACKWARD}

const BASE_MOTION_SPEED = 300
const ROTATION_SPEED = 1000

onready var tilemap: MyTileMap = get_parent()

onready var my_tile: Tile = tilemap.get_map_tile(self.position, true)
onready var dest_tile: Tile = my_tile
onready var bump_tile: Tile = my_tile

var moving: bool = false
var spinning: bool = false
var bumping: int = 0

func _ready() -> void:
	print("Starting location. %s" % my_tile)


func _input(_InputEvent: InputEvent) -> void:
	if not spinning and not moving:
		var input := get_input_vector(_InputEvent)
		var hex_motion := input_to_hex_motion(input)
		if hex_motion != Vector2.ZERO:
			var target_tile = tilemap.get_map_tile(my_tile.coords + hex_motion)
			if target_tile.is_moveable():
				dest_tile = target_tile
				moving = true
			else:
				#spinning = true
				bump_tile = target_tile
				bumping = BumpState.FORWARD


func move_to_hex(target_tile: Tile) -> bool:
	if target_tile.is_moveable():
		dest_tile = target_tile
		moving = true
		return true
	else:
		print("ERROR: Tile unmoveable! %s" % target_tile)
		spinning = true
		return false


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
		motion.y = min(motion.y, 0) if int(my_tile.coords.x) % 2 == 0 else max(motion.y, 0)
	return motion


func get_hex_direction(direction_vector: Vector2) -> int:
	var direction = HexDirection.STOPPED
	if direction_vector == Vector2.ZERO:
		return direction
	else:
		if direction_vector.x == 0 and direction_vector.y < 0:
			direction = HexDirection.UP
		if direction_vector.x > 0 and direction_vector.y < 0:
			direction = HexDirection.UP_RIGHT
		if direction_vector.x > 0 and direction_vector.y > 0:
			direction = HexDirection.DOWN_RIGHT
		if direction_vector.x < 0 and direction_vector.y > 0:
			direction = HexDirection.DOWN_LEFT
		if direction_vector.x < 0 and direction_vector.y < 0:
			direction = HexDirection.UP_LEFT
		if direction_vector.x == 0 and direction_vector.y > 0:
			direction = HexDirection.DOWN
	return direction


func get_input_vector(_Input: InputEvent) -> Vector2:
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if motion != Vector2.ZERO:
		return motion
	return Vector2.ZERO


func _physics_process(delta) -> void:
	move(delta)
	spin(delta)
	bump(delta)


func move(delta) -> void:
	if not moving:
		return
	var speed := BASE_MOTION_SPEED if not dest_tile.is_slow() else BASE_MOTION_SPEED / 2
	var step := position.move_toward(dest_tile.position, delta * speed) - position
	move_and_collide(step)
	if position == dest_tile.position:
		my_tile = dest_tile
		moving = false


func spin(delta) -> void:
	if not spinning:
		return
	rotation_degrees += ROTATION_SPEED * delta
	if rotation_degrees >= 360:
		rotation_degrees = 0
		spinning = false


func bump(delta) -> void:
	if not bumping:
		return
	var speed := BASE_MOTION_SPEED
	var target_tile = my_tile
	var target_position = my_tile.position
	if bumping == BumpState.FORWARD:
		target_tile = bump_tile
		target_position = target_tile.position - ((target_tile.position - my_tile.position) / 2)
	#print("Tiles. MyTile: %s, BumpTile: %s, TargetTile: %s" % [my_tile, bump_tile, target_tile])
	var step := position.move_toward(target_position, delta * speed) - position
	move_and_collide(step)
	if position == target_position:
		bumping += 1
		if bumping >= BumpState.size():
			bumping = BumpState.STOPPED


