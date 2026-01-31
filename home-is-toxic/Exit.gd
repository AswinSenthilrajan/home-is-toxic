extends Area2D

@export var target_room: PackedScene
@export var entry_spawn_name: String = ""

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		# Get world and change room
		var world = get_tree().get_first_node_in_group("world")
		if world:
			world.change_room(target_room, entry_spawn_name)
