extends Node2D
class_name World

@onready var room_container: Node2D = $RoomContainer
@onready var player: Player = $Player
@onready var hud: Hud = $HUD
@onready var map: MapRooms = $Map
@onready var outsie_music: AudioStreamPlayer = $Outsie_Music
@onready var inside_music: AudioStreamPlayer = $Inside_music

var current_packedScene: PackedScene = null
var current_scene: Node2D = null
var remaining_airTime: float
const GAME_OVER_UI := preload("res://scenes/gui/GameOver.tscn")
var game_over: Control
var inside = false

func enter_house():
	if inside:
		inside = false
		player.entered_gas()
	else:
		inside = true
		player.exited_gas()

func _ready():
	add_to_group("world")
	hud.update_max_air(player.airTime)
	player.reset_health()
	# load starting room
	_change_room(map.center, Vector2(0,0))

func _process(delta: float) -> void:
	var door: Door = get_tree().get_first_node_in_group("door")
	remaining_airTime = player.air_timer.time_left
	hud.update_air_bar(remaining_airTime)
	if door and not door.entered_door.is_connected(enter_house):
		door.entered_door.connect(enter_house)
	if inside and not inside_music.playing:
		outsie_music.stop()
		inside_music.play()
	elif not inside and not outsie_music.playing:
		inside_music.stop()
		outsie_music.play()

func _find_spawn_marker(room: Node, spawn_name: StringName) -> Marker2D:
	var s := room.get_node_or_null("Spawns/" + String(spawn_name))
	if s is Marker2D:
		return s
	return null

func change_special_room(room: PackedScene)-> void:
	if current_scene:
		current_scene.queue_free()
	current_packedScene = room
	current_scene  = current_packedScene.instantiate()
	room_container.add_child(current_scene)
	await get_tree().process_frame
	var door: Door = get_tree().get_first_node_in_group("door")
	player.global_position = door.door_spawm.global_position


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


func _on_player_died() -> void:
	get_tree().paused = true
	game_over = GAME_OVER_UI.instantiate()
	add_child(game_over) # or add to a CanvasLayer if you have one


func _on_player_max_air_changed(new_max: float) -> void:
	hud.update_max_air(new_max)

func _on_player_picked_up_item(item: Interactable) -> void:
	hud.add_item(item)

func _on_player_used_item(item: Interactable) -> void:
	hud.remove_item(item)
