extends Node
class_name Inventory

var items: Dictionary = {}  # item_id -> count

func add_item(item_id: StringName, amount: int = 1) -> void:
	items[item_id] = int(items.get(item_id, 0)) + amount
	print("Picked up:", item_id, "x", amount, "Total:", items[item_id])

func has_item(item_id: StringName, amount: int = 1) -> bool:
	return int(items.get(item_id, 0)) >= amount
