extends Node2D

@onready var room_container: Node2D = $RoomContainer
@onready var player: Node2D = $Player

var current_room: Room = null

func _ready():
	# load starting room
	_change_room(preload("res://scenes/rooms/Room_00.tscn"), Vector2(0,0))

func _find_spawn_marker(room: Node, spawn_name: StringName) -> Marker2D:
	var s := room.get_node_or_null("Spawns/" + String(spawn_name))
	if s is Marker2D:
		return s
	return null


func _change_room(next_room: PackedScene, player_position: Vector2) -> void:
	if current_room:
		current_room.queue_free()

	current_room = next_room.instantiate()
	room_container.add_child(current_room)
	player.global_position = player_position

func _get_new_player_pos(side: int, body: CharacterBody2D) -> Vector2:
	var value: Vector2
	match side:
		0: value = Vector2(-1*body.global_position.x, body.global_position.y)
		1: value = Vector2(body.global_position.x, -1* body.global_position.y)
		2: value = Vector2(-1*body.global_position.x, body.global_position.y)
		3: value = Vector2(body.global_position.x, -1* body.global_position.y)
	print("player left: " + str(body.global_position))
	print("calculated: " + str(value))
	return value


func _on_world_bounds_player_exited(body: CharacterBody2D, side: int) -> void:
	var next_room = current_room.getRoom(side)
	var player_position = _get_new_player_pos(side, body)
	if room_container and current_room:
		_change_room(next_room,player_position)
