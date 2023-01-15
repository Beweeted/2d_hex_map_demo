extends KinematicBody2D

enum HexDirection {STOPPED = -1, UP, UP_RIGHT, DOWN_RIGHT, DOWN, DOWN_LEFT, UP_LEFT}
enum BumpState {STOPPED, FORWARD, BACKWARD}

const BASE_MOTION_SPEED = 300
const ROTATION_SPEED = 1000

onready var my_tile: Tile
onready var dest_tile: Tile
onready var bump_tile: Tile

var moving: bool = false
var spinning: bool = false
var bumping: int = 0


func reset_tile(tilemap: MyTileMap) -> void:
	my_tile = tilemap.get_map_tile(self.position, true)
	dest_tile = my_tile
	bump_tile = my_tile
	print("Reinitializing tile location. %s" % my_tile)


func move_to_hex(target_tile: Tile) -> bool:
	if target_tile.is_moveable():
		dest_tile = target_tile
		moving = true
		return true
	else:
		print("ERROR: Tile unmoveable! %s" % target_tile)
		spinning = true
		return false


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


func is_animating() -> bool:
	if moving or spinning or bumping != BumpState.STOPPED:
		return true
	return false


func move(delta) -> void:
	if not moving:
		return
	var speed := BASE_MOTION_SPEED if not dest_tile.is_slow() else BASE_MOTION_SPEED / 2
	var step := position.move_toward(dest_tile.position, delta * speed) - position
	move_and_collide(step)
	if position == dest_tile.position:
		my_tile = dest_tile
		moving = false
		print("Move finished")


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
			print("Bump finished")


func _physics_process(delta) -> void:
	move(delta)
	spin(delta)
	bump(delta)
