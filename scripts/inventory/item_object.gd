extends Area2D

var rng: int

func _ready() -> void:
	var tween = create_tween()
	var rng_position = Vector2(randi_range(-30, 30), randi_range(-30, 30))
	tween.tween_property(self, "position", position + rng_position, 0.2)
	rng = randi_range(0, 3)
	get_node("Tile0118").texture = Global.items[rng].item_texture


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		get_node("../../gui/inventory").add_item(rng)
		get_node("pickup").play()
		get_node("Tile0118").hide()

func _on_pickup_finished() -> void:
	self.queue_free()
