extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_pressed() -> void:
	get_tree().paused = false 
	get_tree().reload_current_scene()
	
func game_over() -> void:
	self.show()
	get_tree().paused = true
