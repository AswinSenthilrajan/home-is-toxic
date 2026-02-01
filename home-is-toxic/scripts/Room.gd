extends Node2D
class_name Room

const ROOMS := {
	0: preload("res://scenes/rooms/Room_01.tscn"),
	1: preload("res://scenes/rooms/Room_00.tscn"),
	2: preload("res://scenes/rooms/Room_00.tscn"),
	3: preload("res://scenes/rooms/Room_00.tscn"),
}

func getRoom(side: int) -> PackedScene:
	return ROOMS.get(side)
