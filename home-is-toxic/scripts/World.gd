extends Node2D

@onready var room_container: Node2D = $RoomContainer
@onready var player: Node2D = $Player

var current_room: Node = null

func _ready():
	# load starting room
	change_room(preload("res://rooms/Room_01.tscn"), "Spawn_Start")

func change_room(next_room: PackedScene, entry_spawn_name: String):
	# remove old
	if current_room:
		current_room.queue_free()

	current_room = next_room.instantiate()
	room_container.add_child(current_room)

	# place player at spawn
	if entry_spawn_name != "":
		var spawn = current_room.get_node_or_null(entry_spawn_name)
		if spawn and spawn is Marker2D:
			player.global_position = spawn.global_position
