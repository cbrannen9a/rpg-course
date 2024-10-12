extends CharacterBody2D

@onready var arrow_scene: PackedScene = preload("res://scenes/projectiles/arrow.tscn")
@onready var sprite = get_node("Tile0109")
@onready var hp_bar = get_node("ProgressBar")
var player: CharacterBody2D
var speed: float = 800.0
var health: int = 5
var player_buffer: int = 30
var state: Global.state_types = Global.state_types.ACTIVE
var direction: Vector2
var damage: int = 1

func _ready() -> void:
	hp_bar.max_value = health
	player = get_node("../Player")
	
func _physics_process(delta: float) -> void:
	hp_bar.value = health
	if is_instance_valid(player) and Global.move_state_types.has(state):
		direction = (player.global_position - self.global_position).normalized()
		if position.distance_to(player.position) > player_buffer:
			self.velocity = direction * speed * delta
		else:
			self.velocity = Vector2.ZERO
			
		if direction.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		move_and_slide()

func hit(hit_damage: int):
	health -= hit_damage
	if health <= 0:
		state = Global.state_types.DYING
		get_node("AnimationPlayer").play("death")
		await get_node("AnimationPlayer").animation_finished
		
		self.queue_free()
		
func ranged_attack(target_pos):
	var arrow_temp = arrow_scene.instantiate()
	arrow_temp.direction = target_pos
	arrow_temp.look_at(target_pos)
	arrow_temp.owner_name = "monster"
	arrow_temp.damage = self.damage
	arrow_temp.global_position = self.global_position
	get_node("../Projectiles").add_child(arrow_temp)


func _on_timer_timeout() -> void:
	if is_instance_valid(player) and Global.move_state_types.has(state):
		ranged_attack(direction)
