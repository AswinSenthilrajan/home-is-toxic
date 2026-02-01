extends StaticBody2D
class_name Gas

@export var required_value: int = 1

@onready var wall_col: CollisionShape2D = $Wall
@onready var sensor: Area2D = $Sensor

signal level_not_suficient


func _ready() -> void:
	sensor.monitoring = true
	sensor.body_entered.connect(_on_sensor_body_entered)
	sensor.body_exited.connect(_on_sensor_body_exited)


func _has_property(obj: Object, prop: StringName) -> bool:
	for p in obj.get_property_list():
		print(p.name)
		if p.name == prop:
			return true
	return false

func set_gas_level(level : int) -> void:
	required_value = level

func _on_sensor_body_entered(body: Node) -> void:
	print(body.name)
	if not body.name == "Player":
		return
	var player = body as Player
	if not _has_property(player, &"gas_mask_level"):
		return

	var gas_level := int(player.get(&"gas_mask_level"))

	# matches required value (exact match)
	if gas_level == required_value:
		wall_col.set_deferred("disabled", true)
	else:
		level_not_suficient.emit()
		wall_col.set_deferred("disabled", false)


func _on_sensor_body_exited(body: Node) -> void:
	if not body.name == "Player":
		return
	wall_col.set_deferred("disabled", false)
