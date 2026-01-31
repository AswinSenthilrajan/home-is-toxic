extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal player_exited(body: Area2D, side: int)
# exit_side: 0=N, 1=E, 2=S, 3=W

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		var rect = collision_shape.shape
		var ext = rect.extents
		var local := to_local(body.global_position)
		#Right
		if local.x < -ext.x:
			player_exited.emit(body,3)
		#Left
		elif local.x > ext.x:
			player_exited.emit(body,1)
		#Top
		elif local.y < -ext.y:
			player_exited.emit(body,0)
		#Bottom
		elif local.y > ext.y:
			player_exited.emit(body,2)
