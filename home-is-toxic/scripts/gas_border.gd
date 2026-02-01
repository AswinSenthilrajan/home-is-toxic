extends Node2D

@export var gas_level_right: int = 1
@export var gas_level_top: int = 1
@export var gas_level_left: int = 1
@export var gas_level_bottom: int = 1

@onready var gas_bottom: Gas = $Gas_Bottom
@onready var gas_right: Gas = $Gas_right
@onready var gas_top: Gas = $Gas_Top
@onready var gas_left: Gas = $Gas_left


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gas_bottom.set_gas_level(gas_level_bottom)
	gas_right.set_gas_level(gas_level_right)
	gas_top.set_gas_level(gas_level_top)
	gas_left.set_gas_level(gas_level_left)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
