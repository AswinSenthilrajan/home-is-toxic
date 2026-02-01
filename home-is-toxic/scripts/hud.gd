extends CanvasLayer
class_name Hud

@export var atlas: Texture2D

@onready var health_row: HBoxContainer = $Root/MarginContainer/VBoxContainer/HealthRow
@onready var air_bar: ProgressBar = %AirBar

const FULL  = Rect2i(0,   0, 32, 32)
const HALF  = Rect2i(32,  0, 32, 32)
const EMPTY = Rect2i(64,  0, 32, 32)
var regions = [FULL, HALF, EMPTY]

var _children

func _ready() -> void:
	_children = health_row.get_children()
	for heart in _children:
		var texture := AtlasTexture.new()
		texture.atlas = atlas
		texture.region = FULL
		heart.texture = texture
	set_health(5)
	

func update_air_bar(new_air: float) -> void:
	air_bar.set_value_no_signal(new_air)

func update_max_air(new_max: float) -> void:
	if air_bar:
		air_bar["max_value"] = new_max
	
func set_health(current_health: int):
	for i in range(_children.size()):
		var heart_hp = clamp(current_health - i * 2, 0, 2)
		var tex := health_row.get_child(i).texture as AtlasTexture

		match heart_hp:
			2: tex.region = FULL
			1: tex.region = HALF
			0: tex.region = EMPTY
