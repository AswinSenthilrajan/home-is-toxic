extends Node
class_name MapRooms

# exit_side: 0=N, 1=E, 2=S, 3=W

@export var center: PackedScene

@export var ring1: Array[PackedScene] = []:
	set(v): ring1 = v.slice(0, 8)

@export var ring2: Array[PackedScene] = []:
	set(v): ring2 = v.slice(0, 16)

@export var ring3: Array[PackedScene] = []:
	set(v): ring3 = v.slice(0, 24) # square ring radius 3 perimeter = 24


const DIRS := [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]

var _scene_to_coord: Dictionary = {} # PackedScene -> Vector2i
var _coord_to_scene: Dictionary = {} # Vector2i -> PackedScene


func _ready() -> void:
	_reindex()


func get_neighbor(room: PackedScene, exit_side: int) -> PackedScene:
	print("\n--- get_neighbor ---")
	print("exit_side:", exit_side)

	if room == null:
		print("room == null")
		return null

	print("room path:", room.resource_path)

	if exit_side < 0 or exit_side > 3:
		print("invalid exit_side")
		return null

	if _scene_to_coord.is_empty() or _coord_to_scene.is_empty():
		print("index empty -> reindex()")
		_reindex()
		print("after reindex: scene_to_coord size =", _scene_to_coord.size(), " coord_to_scene size =", _coord_to_scene.size())

	var c: Vector2i = _scene_to_coord.get(room, Vector2i(9999, 9999))
	print("current coord:", c)

	if c.x == 9999:
		print("room not found in _scene_to_coord. Known rooms:")
		if center != null:
			print(" center:", center.resource_path)
		for i in range(ring1.size()):
			if ring1[i] != null: print(" ring1[", i, "] ", ring1[i].resource_path)
		for i in range(ring2.size()):
			if ring2[i] != null: print(" ring2[", i, "] ", ring2[i].resource_path)
		for i in range(ring3.size()):
			if ring3[i] != null: print(" ring3[", i, "] ", ring3[i].resource_path)
		return null

	var d: Vector2i = _scene_to_coord.get(room, Vector2i(9999, 9999))
	if d.x == 9999:
		return null
	var target: Vector2i = c + DIRS[exit_side]
	print("target coord:", target)

	var next_room: PackedScene = _coord_to_scene.get(target, null)
	if next_room == null:
		print("no room at target coord. coord_to_scene keys sample:")
		var keys := _coord_to_scene.keys()
		for i in range(mini(keys.size(), 40)):
			print(" ", keys[i], " -> ", (_coord_to_scene[keys[i]] as PackedScene).resource_path)
		return null

	print("next room path:", next_room.resource_path)
	return next_room

func _reindex() -> void:
	_scene_to_coord.clear()
	_coord_to_scene.clear()

	if center != null:
		_scene_to_coord[center] = Vector2i.ZERO
		_coord_to_scene[Vector2i.ZERO] = center

	_place_ring(1, ring1)
	_place_ring(2, ring2)
	_place_ring(3, ring3)


func _place_ring(r: int, ring: Array[PackedScene]) -> void:
	var coords := _ring_coords(r)
	var n := mini(coords.size(), ring.size())
	for i in range(n):
		var ps := ring[i]
		if ps == null:
			continue
		_scene_to_coord[ps] = coords[i]
		_coord_to_scene[coords[i]] = ps


# Clockwise ring order, start at (0, -r):
# r=1 => 8 coords, r=2 => 16, r=3 => 24
func _ring_coords(r: int) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	if r <= 0:
		return out

	var p := Vector2i(0, -r)
	out.append(p)

	for _i in range(r):         p += Vector2i(1, 0);  out.append(p)  # top
	for _i in range(2 * r):     p += Vector2i(0, 1);  out.append(p)  # right
	for _i in range(2 * r):     p += Vector2i(-1, 0); out.append(p)  # bottom
	for _i in range(2 * r):     p += Vector2i(0, -1); out.append(p)  # left
	for _i in range(r - 1):     p += Vector2i(1, 0);  out.append(p)  # finish top (excluding start)

	return out
