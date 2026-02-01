extends CanvasLayer
class_name Hud

@export var atlas: Texture2D

@onready var health_row: HBoxContainer = $Root/MarginContainer/VBoxContainer/HealthRow
@onready var air_bar: ProgressBar = %AirBar
@onready var hot_bar: Control = $Root/HotBar

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
	if not air_bar:
		return

	var old_max := air_bar.max_value
	var ratio := 0.0
	if old_max > 0.0:
		ratio = air_bar.value / old_max   # keep the same percentage

	air_bar.max_value = new_max
	air_bar.value = clamp(ratio * new_max, air_bar.min_value, new_max)

	
func set_health(current_health: int):
	for i in range(_children.size()):
		var heart_hp = clamp(current_health - i * 2, 0, 2)
		var tex := health_row.get_child(i).texture as AtlasTexture

		match heart_hp:
			2: tex.region = FULL
			1: tex.region = HALF
			0: tex.region = EMPTY

func add_item(item: Interactable):
	var slot: HotbarSlot = HotbarSlot.new()
	var tex: Texture2D = load("res://sprites/"+item.get_class())
	slot.icon.texture = tex
	hot_bar.add_child(slot)

func remove_item(item: Interactable):
	var slot: HotbarSlot = hot_bar.get_children().filter(func(el): return el is HotbarSlot).map(func(el): return el as HotbarSlot).filter(func(el): return el.item==item).get(1)
	slot.remove_item()
	
