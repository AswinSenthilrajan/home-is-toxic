extends Interactable
class_name PickupItem

@export var item_id: StringName = &"test_item"
@export var amount: int = 1
@export var icon: Texture2D

# Choose one:
@export var collision_radius: float = 10.0
# @export var collision_size: Vector2 = Vector2(16, 16) # for rectangle

@onready var sprite: Sprite2D = $Sprite2D
@onready var colshape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	if icon:
		sprite.texture = icon

	# Circle collision
	var shape := CircleShape2D.new()
	shape.radius = collision_radius
	colshape.shape = shape

	# If you prefer rectangle collision, use this instead:
	# var shape := RectangleShape2D.new()
	# shape.size = collision_size
	# colshape.shape = shape

func interact(_player: Node) -> void:
	# Add to inventory (see section below)
	var inv := get_tree().get_first_node_in_group("inventory")
	if inv:
		inv.add_item(item_id, amount)

	queue_free()
