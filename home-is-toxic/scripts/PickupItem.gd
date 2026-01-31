extends Interactable
class_name PickupItem

@export var item_id: StringName = &"key"
@export var amount: int = 1

func interact(_player: Node) -> void:
	# Add to inventory (see section below)
	var inv := get_tree().get_first_node_in_group("inventory")
	if inv:
		inv.add_item(item_id, amount)

	queue_free()
