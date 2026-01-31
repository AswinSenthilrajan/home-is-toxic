extends CharacterBody2D

@export var speed: float = 120.0
@export var sprint_multiplier = 5.0

@onready var interact_area: Area2D = $InteractArea
var nearby: Array[Interactable] = []
var current: Interactable = null

func _ready() -> void:
	interact_area.area_entered.connect(_on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)

func _physics_process(_delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed;
	
	if dir != Vector2.ZERO and Input.is_action_pressed("sprint"):
		velocity *= sprint_multiplier
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if current:
			current.interact(self)

func _on_area_entered(area: Area2D) -> void:
	if area is Interactable:
		nearby.append(area)
		_pick_best()

func _on_area_exited(area: Area2D) -> void:
	if area is Interactable:
		nearby.erase(area)
		_pick_best()

func _pick_best() -> void:
	# Choose closest interactable
	var best: Interactable = null
	var best_dist := INF
	for it in nearby:
		if not is_instance_valid(it):
			continue
		var d := global_position.distance_squared_to(it.global_position)
		if d < best_dist:
			best_dist = d
			best = it
	current = best
