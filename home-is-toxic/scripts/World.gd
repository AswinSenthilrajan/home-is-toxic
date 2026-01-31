extends Node2D

@onready var room_container: Node2D = $RoomContainer
@onready var player: Node2D = $Player

var current_room: Node = null

func _ready():
	# load starting room
	change_room(preload("res://scenes/rooms/Room_01.tscn"), "Spawn_Start")

func _find_spawn_marker(room: Node, spawn_name: StringName) -> Marker2D:
	var s := room.get_node_or_null("Spawns/" + String(spawn_name))
	if s is Marker2D:
		return s
	return null


func change_room(next_room: PackedScene, entry_spawn_name: StringName) -> void:
	if current_room:
		current_room.queue_free()

	current_room = next_room.instantiate()
	room_container.add_child(current_room)

	var spawn: Marker2D = _find_spawn_marker(current_room, entry_spawn_name)

	if spawn:
		player.global_position = spawn.global_position
