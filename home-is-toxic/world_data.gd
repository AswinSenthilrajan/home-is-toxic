extends Node

@onready var hud: CanvasLayer = %HUD
@onready var player: CharacterBody2D = %Player

var remaining_airTime = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.update_max_air(player.airTime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remaining_airTime = player.air_timer.time_left
	hud.update_air_bar(remaining_airTime)

func _on_player_health_changed(new_health: int) -> void:
	hud.set_health(new_health)
