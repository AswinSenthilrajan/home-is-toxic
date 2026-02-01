extends MarginContainer
class_name HotbarSlot

@onready var icon: TextureRect = $Border/Icon

var item: Interactable = null

func set_item(_item: Interactable)->void:
	item=_item
	var tex: Texture2D = load("res://sprites/"+item.get_class().to_lower()+".png")
	icon.texture=tex

func remove_item()->void:
	icon.texture=null
