extends Interactable
class_name Air_Item

@export var bonus_air_time: float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func  use(_player: Player) -> void:
	_player.add_air_time(bonus_air_time)
