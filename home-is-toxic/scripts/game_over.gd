extends Control

func _on_quit() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
