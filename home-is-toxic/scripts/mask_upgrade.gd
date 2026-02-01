extends Interactable
class_name Mask_Upgrade

@export var bonus_max_air_time: float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func  interact(_player: Player) -> void:
	_player.update_max_air(bonus_max_air_time)
