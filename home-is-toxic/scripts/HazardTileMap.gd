extends TileMapLayer
class_name HazardTileMap

@export var damage_per_tick: int = 1
@export var damage_tick_time: float = 0.5

var player_timers: Dictionary = {}  # Player -> Timer

func on_player_entered(player: Player) -> void:
	if player_timers.has(player):
		return

	var timer := Timer.new()
	timer.wait_time = damage_tick_time
	timer.one_shot = false
	timer.autostart = true

	add_child(timer)

	player_timers[player] = timer
	timer.timeout.connect(_on_timer_timeout.bind(player))

func on_player_exited(player: Player) -> void:
	if not player_timers.has(player):
		return

	var timer: Timer = player_timers[player]
	timer.stop()
	timer.queue_free()
	player_timers.erase(player)

func _on_timer_timeout(player: Player) -> void:
	if not is_instance_valid(player):
		return

	player.apply_damage(damage_per_tick)
