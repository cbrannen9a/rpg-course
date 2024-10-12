extends CharacterBody2D

@onready var arrow_scene: PackedScene = preload("res://scenes/projectiles/arrow.tscn")
@onready var weapon_marker = get_node("Weapons")
@onready var melee_weapon = get_node("Weapons/Melee")
@onready var ranged_weapon = get_node("Weapons/Ranged")
@onready var hp_bar = get_node("ProgressBar")
@export var speed: int = 80

var state: Global.state_types = Global.state_types.ACTIVE
var health: int = 5
var damage: int = 2
var attack_speed: float = 0.1

func _ready() -> void:
	hp_bar.max_value = health
	
func _physics_process(delta: float) -> void:
	
	if Global.move_state_types.has(state):
		weapon_marker.look_at(get_global_mouse_position())
		attack_check(delta)
		var input_vector: Vector2 = Vector2.ZERO
		
		input_vector.x = Input.get_action_strength("walkRight") - Input.get_action_strength("walkLeft")
		input_vector.y = Input.get_action_strength("walkDown") - Input.get_action_strength("walkUp")
		
		velocity = input_vector * speed
		move_and_slide()


func _on_melee_body_entered(body: Node2D) -> void:
	if state == Global.state_types.MELEE and body.is_in_group("monster"):
		body.hit(damage)
		

func attack_check(delta: float):
	if Input.is_action_just_pressed("attack") and state != Global.state_types.MELEE:
		var target_position: Vector2 = (get_global_mouse_position() - weapon_marker.global_position).normalized()
		if state != Global.state_types.MELEE and melee_weapon.visible:
			melee_attack(target_position)
		if state != Global.state_types.RANGED and ranged_weapon.visible:
			ranged_attack(target_position)

	
func melee_attack(target_pos):
	state = Global.state_types.MELEE
	var tween = create_tween()
	
	tween.tween_property(weapon_marker, "position", target_pos * 10, 0.2)
	tween.tween_callback(return_default)
	
func ranged_attack(target_pos):
	get_node("Weapons/Ranged/Timer").start()
	state = Global.state_types.RANGED
	var arrow_temp = arrow_scene.instantiate()
	arrow_temp.direction = target_pos
	arrow_temp.look_at(target_pos)
	arrow_temp.owner_name = "player"
	arrow_temp.damage = self.damage
	arrow_temp.global_position = self.global_position
	get_node("../Projectiles").add_child(arrow_temp)
	

func return_default():
	var tween = create_tween()
	
	tween.tween_property(weapon_marker, "position", Vector2.ZERO, 0.2)
	await get_tree().create_timer(attack_speed).timeout
	state = Global.state_types.ACTIVE


func _on_timer_timeout() -> void:
	state = Global.state_types.ACTIVE

func hit(damage: int):
	health -= damage
	hp_bar.value = health
	if health <= 0:
		state = Global.state_types.DYING
		get_node("../game_over").game_over()
