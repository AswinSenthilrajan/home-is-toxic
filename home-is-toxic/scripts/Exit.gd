extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal player_exited(body: Area2D, side: int)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		var rect = collision_shape.shape
		var ext = rect.extents
		var local := to_local(body.global_position)
		if local.x < -ext.x:
			player_exited.emit(body,0)
		elif local.x > ext.x:
			player_exited.emit(body,2)
		elif local.y < -ext.y:
			player_exited.emit(body,1)
		elif local.y > ext.y:
			player_exited.emit(body,3)
