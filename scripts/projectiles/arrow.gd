extends Area2D


var direction: Vector2 = Vector2(0, 0)
var speed: int = 100
var owner_name: String = ""
var damage: int = 1


func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if (owner_name == "player" and body.is_in_group("monster")) or (owner_name == "monster" and body.is_in_group("player")):
		body.hit(damage)
		get_node("Tile0119").hide()
		get_node("CPUParticles2D").emitting = true


func _on_cpu_particles_2d_finished() -> void:
	self.queue_free()