extends Control

@export var world_scene: PackedScene

func _ready():
	$CenterContainer/VBoxContainer/Buttons/PlayButton.pressed.connect(_on_play)
	$CenterContainer/VBoxContainer/Buttons/QuitButton.pressed.connect(_on_quit)

func _on_play():
	get_tree().change_scene_to_packed(world_scene)

func _on_quit():
	get_tree().quit()
