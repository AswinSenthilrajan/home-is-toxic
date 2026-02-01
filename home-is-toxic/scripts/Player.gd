extends CharacterBody2D
class_name Player

@export var speed: float = 120.0
@export var sprint_multiplier = 5.0
@export var max_health: int = 18
@export var airTime: float = 10.0
@export var no_air_damage_tick_time: float = 1.0
@onready var air_timer: Timer = $Air_Timer
@onready var no_air_tick: Timer = $No_Air_Tick
@onready var interact_area: Area2D = $InteractArea
var nearby: Array[Interactable] = []
var current: Interactable = null
var health: float = max_health

signal health_changed(new_health: int)
signal max_air_changed(new_max: float)
signal died()

func _ready() -> void:
	health_changed.emit(health)
	entered_gas()

func entered_gas() -> void:
	air_timer.start(airTime)

func exited_gas() -> void:
	air_timer.stop()

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
	
func apply_damage(damage: int) -> void:
	health -= damage
	if health==0:
		died.emit()
	health_changed.emit(health)

func set_health(new_health: int) -> void:
	health = new_health
	if health==0:
		died.emit()
	health_changed.emit(health)
	
func reset_health() -> void:
	health = max_health
	health_changed.emit(health)
	
func add_air_time(extension_time) -> void:
	var remaining_air = air_timer.time_left
	air_timer.stop()
	var new_time = remaining_air + extension_time
	if new_time > airTime:
		air_timer.start(airTime)
	else:
		air_timer.start(new_time)
		
func update_max_air(new_max: float) -> void:
	airTime = new_max


func _on_interact_area_area_entered(area: Area2D) -> void:
	print("entered area", area)
	if area is Interactable:
		nearby.append(area)
		_pick_best()


func _on_interact_area_area_exited(area: Area2D) -> void:
	print("exited area", area)
	if area is Interactable:
		nearby.erase(area)
		_pick_best()


func _on_air_timer_timeout() -> void:
	print("air run out")
	no_air_tick.start(no_air_damage_tick_time)
	air_timer.stop()


func _on_no_air_tick_timeout() -> void:
	if health > 0:
		apply_damage(1)
		no_air_tick.start(no_air_damage_tick_time)
	else:
		died.emit()
