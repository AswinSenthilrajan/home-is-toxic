extends CharacterBody2D
class_name Player

@export var speed: float = 120.0
@export var sprint_multiplier = 2.0
@export var max_health: int = 18
@export var airTime: float = 10.0
@export var no_air_damage_tick_time: float = 1.0
@export var inventory_size: int = 3
@export var gas_mask_level: int = 1

@onready var air_timer: Timer = $Air_Timer
@onready var no_air_tick: Timer = $No_Air_Tick
@onready var interact_area: Area2D = $InteractArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walking_player: AudioStreamPlayer2D = $Walking_Player
@onready var pick_up_player: AudioStreamPlayer2D = $PickUp_Player
@onready var mask_breath_player: AudioStreamPlayer2D = $Mask_Breath_Player
@onready var death_player: AudioStreamPlayer2D = $Death_Player
@onready var demage_player: AudioStreamPlayer2D = $Demage_Player

var nearby: Array[Interactable] = []
var current: Interactable = null
var health: float = max_health
var walking: = false

var inventory: Array[Interactable] = []

signal health_changed(new_health: int)
signal max_air_changed(new_max: float)
signal died()
signal picked_up_item(item: Interactable)
signal used_item(item: Interactable)

func _ready() -> void:
	add_to_group("player")
	health_changed.emit(health)
	entered_gas()

func entered_gas() -> void:
	air_timer.start(airTime)
	mask_breath_player.play()

func exited_gas() -> void:
	mask_breath_player.stop()
	air_timer.stop()
	no_air_tick.stop()

func _physics_process(_delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	var animation = "idle"
	if(dir.x>0):
		walking = true
		animation = "walk_right"
	elif(dir.x<0):
		walking = true
		animation = "walk_left"
	elif(dir.y>0):
		walking = true
		animation = "walk_down"
	elif(dir.y<0):
		walking = true
		animation = "walk_up"
	if animated_sprite.animation != animation:
		animated_sprite.play(animation)
	if walking and not walking_player.playing:
		walking_player.play()
	elif animation == "idle" and walking_player.playing:
		walking_player.stop()
	velocity = dir * speed;
	var animation_speed := 1.0
	
	if dir != Vector2.ZERO and Input.is_action_pressed("sprint"):
		velocity *= sprint_multiplier
		animation_speed = sprint_multiplier
	if(animated_sprite.speed_scale != animation_speed):
		animated_sprite.speed_scale = animation_speed
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if current:
			if inventory.size() == inventory_size:
				print("Inventory Full")
			else:
				pick_up_player.play()
				picked_up_item.emit(current)
				inventory.push_front(current)
				current.get_parent().remove_child(current)

	elif event.is_action_pressed("item1"):
		var item = inventory.get(0)
		inventory.remove_at(0)
		use_item(item)
	elif event.is_action_pressed("item2"):
		var item = inventory.get(1)
		inventory.remove_at(1)
		use_item(item)
	elif event.is_action_pressed("item3"):
		var item = inventory.get(2)
		inventory.remove_at(2)
		use_item(item)

func use_item(item: Interactable) -> void:
	if item:
		print(item)
		item.use(self)
		used_item.emit(item)

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
	demage_player.play()
	health -= damage
	if health==0:
		died.emit()
	health_changed.emit(health)
	
func apply_damage_air(damage: int) -> void:
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
		no_air_tick.stop()
	else:
		air_timer.start(new_time)
		
func update_max_air(add_max: float) -> void:
	airTime += add_max
	max_air_changed.emit(airTime)

func increase_mask_level(new_level:int) -> void:
	gas_mask_level = new_level

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


func _on_no_air_tick_timeout() -> void:
	if not air_timer.time_left > 0:
		apply_damage(1)
		no_air_tick.start(no_air_damage_tick_time)
		if mask_breath_player.playing:
			mask_breath_player.stop()
	elif not health > 0:
		died.emit()
	else:
		mask_breath_player.play()
		

func _on_hit_box_body_entered(_body: Node2D) -> void:
	if(_body is HazardTileMap):
		var tilemap = _body as HazardTileMap
		tilemap.on_player_entered(self)

func _on_hit_box_body_exited(_body: Node2D) -> void:
	if(_body is HazardTileMap):
		var tilemap = _body as HazardTileMap
		tilemap.on_player_exited(self)


func _on_air_timer_timeout() -> void:
	no_air_tick.start(no_air_damage_tick_time)
	air_timer.stop()
