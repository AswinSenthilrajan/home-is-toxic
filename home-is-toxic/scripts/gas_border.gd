extends Node2D

@export var player_mask_level: int =1

@export var gas_level_right: int = 1
@export var gas_level_top: int = 1
@export var gas_level_left: int = 1
@export var gas_level_bottom: int = 1

@onready var gas_bottom: Gas = $Gas_Bottom
@onready var gas_right: Gas = $Gas_right
@onready var gas_top: Gas = $Gas_Top
@onready var gas_left: Gas = $Gas_left
@onready var gas_images_bottom: Node2D = $Gas_Images_Bottom
@onready var gas_images_top: Node2D = $Gas_Images_Top
@onready var gas_images_right: Node2D = $Gas_Images_right
@onready var gas_images_left: Node2D = $Gas_Images_left
var player: Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gas_bottom.set_gas_level(gas_level_bottom)
	gas_right.set_gas_level(gas_level_right)
	gas_top.set_gas_level(gas_level_top)
	gas_left.set_gas_level(gas_level_left)
	player = get_tree().get_first_node_in_group("player")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_mask_level = player.gas_mask_level
	_unrender_unneeded_sprites()


func _unrender_unneeded_sprites() -> void:
	if gas_bottom.required_value == player_mask_level:
		for sprite: Sprite2D in gas_images_bottom.get_children():
			sprite.visible = false
	if gas_right.required_value == player_mask_level:
		for sprite: Sprite2D in gas_images_right.get_children():
			sprite.visible = false
	if gas_top.required_value == player_mask_level:
		for sprite: Sprite2D in gas_images_top.get_children():
			sprite.visible = false
	if gas_left.required_value == player_mask_level:
		for sprite: Sprite2D in gas_images_left.get_children():
			sprite.visible = false
	pass
