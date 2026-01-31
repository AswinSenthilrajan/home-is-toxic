extends CanvasLayer
@onready var health_bar: ProgressBar = $Root/MarginContainer/VBoxContainer/HealthRow/HealthBar
@onready var bomb_bar: ProgressBar = $Root/MarginContainer/VBoxContainer/BombRow/BombBar


func update_health(new_health: float)-> void:
	health_bar.set_value_no_signal(new_health)

func update_max_health(new_max: float) -> void:
	health_bar["max_value"] = new_max

func update_bomb_time(new_time: float) -> void:
	bomb_bar.set_value_no_signal(new_time)
	

func update_bomb_max_time(new_max: float) -> void:
	bomb_bar["max_value"] = new_max
