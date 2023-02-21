class_name Unit extends KinematicBody2D

const Terrain = preload("res://terrain.gd")
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

var max_move_points: int
var move_points: int

func _ready():
	recharge_move_points_to_max()

func reset_tile(tilemap: MyTileMap) -> void:
	my_tile = tilemap.get_map_tile(self.position, true)
	dest_tile = my_tile
	bump_tile = my_tile
	print("Reinitializing tile location. %s" % my_tile)


func move_to_hex(target_tile: Tile) -> bool:
	var move_points_cost = calculate_move_cost(target_tile)
	if move_points_cost > move_points:
		print("ERROR: Tile unmoveable! Move points: %s, Move cost: %s, Tile: %s" % [move_points, move_points_cost, target_tile])
		set_bump(target_tile)
		return false
	else:
		print("Move start %s" % target_tile)
		set_moving(target_tile, move_points_cost)
		return true


func set_bump(target_tile: Tile) -> void:
	bump_tile = target_tile
	bumping = BumpState.FORWARD


func set_moving(target_tile: Tile, move_points_cost: int) -> void:
	move_points -= move_points_cost
	dest_tile = target_tile
	moving = true


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


func calculate_move_cost(tile: Tile) -> int:
	return 1


func recharge_move_points_to_max() -> int:
	print("Reset to max! Max: %s" % max_move_points)
	return recharge_move_points(max_move_points)


func recharge_move_points(extra_points: int) -> int:
	print("Recharging move points. Requested amount: %s, Max: %s" % [extra_points, max_move_points])
	move_points = int(min(max_move_points, extra_points))
	return move_points


func move_animation(delta) -> void:
	if not moving:
		return
	var move_cost = calculate_move_cost(dest_tile)
	var speed = BASE_MOTION_SPEED / move_cost
	var step := position.move_toward(dest_tile.position, delta * speed) - position
	move_and_collide(step)
	if position == dest_tile.position:
		my_tile = dest_tile
		moving = false
		print("Move finished. Move points remaining: %s/%s" % [move_points, max_move_points])


func spin_animation(delta) -> void:
	if not spinning:
		return
	rotation_degrees += ROTATION_SPEED * delta
	if rotation_degrees >= 360:
		rotation_degrees = 0
		spinning = false


func bump_animation(delta) -> void:
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
	move_animation(delta)
	spin_animation(delta)
	bump_animation(delta)
