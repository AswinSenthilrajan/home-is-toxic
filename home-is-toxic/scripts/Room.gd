extends Node2D
class_name Room

const ROOMS := {
	0: preload("res://scenes/rooms/Room_00.tscn"),
	1: preload("res://scenes/rooms/Room_00.tscn"),
	2: preload("res://scenes/rooms/Room_00.tscn"),
	3: preload("res://scenes/rooms/Room_00.tscn"),
}

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D


func getRoom(side: int) -> PackedScene:
	return ROOMS.get(side)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
