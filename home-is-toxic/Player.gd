extends CharacterBody2D

@export var speed: float = 120.0

func _physics_process(_delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed
	move_and_slide()
