extends Node2D

@onready var room_container: Node2D = $RoomContainer
@onready var player: Node2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var map: MapRooms = $Map

var current_packedScene: PackedScene = null
var current_scene: Node2D = null
var remaining_airTime: float

func _ready():
	hud.update_max_air(player.airTime)
	player.reset_health()
	player.apply_damage(3)
	# load starting room
	_change_room(map.center, Vector2(0,0))

func _process(delta: float) -> void:
	remaining_airTime = player.air_timer.time_left
	hud.update_air_bar(remaining_airTime)

func _find_spawn_marker(room: Node, spawn_name: StringName) -> Marker2D:
	var s := room.get_node_or_null("Spawns/" + String(spawn_name))
	if s is Marker2D:
		return s
	return null


func _change_room(next_room: PackedScene, player_position: Vector2) -> void:
	if current_scene:
		current_scene.queue_free()
	current_packedScene = next_room
	current_scene  = current_packedScene.instantiate()
	room_container.add_child(current_scene)
	player.global_position = player_position
# exit_side: 0=N, 1=E, 2=S, 3=W

func _get_new_player_pos(side: int, body: CharacterBody2D) -> Vector2:
	var value: Vector2
	match side:
		0: value = Vector2(body.global_position.x, -1* body.global_position.y)
		1: value = Vector2(-1*body.global_position.x, body.global_position.y)
		2: value = Vector2(body.global_position.x, -1* body.global_position.y)
		3: value = Vector2(-1*body.global_position.x, body.global_position.y)
	print("player left: " + str(body.global_position))
	print("calculated: " + str(value))
	return value


func _on_world_bounds_player_exited(body: CharacterBody2D, side: int) -> void:
	var next_room = map.get_neighbor(current_packedScene, side)
	var player_position = _get_new_player_pos(side, body)
	if room_container and current_packedScene:
		_change_room(next_room,player_position)


func _on_player_health_changed(new_health: float) -> void:
		if hud:
			hud.set_health(new_health)
