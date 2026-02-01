extends Area2D
class_name Door

@export_file("*.tscn") var connected_scene_path: String
@export var door_spawm: Node2D

var world: World

signal entered_door()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("door")
	world = get_tree().get_first_node_in_group("world")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if connected_scene_path != "":
			entered_door.emit()
			# Mir laded d'Szene erst hie "on the fly"
			var target_scene = load(connected_scene_path)
			world.change_special_room(target_scene)
		
