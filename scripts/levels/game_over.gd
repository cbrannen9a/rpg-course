extends CanvasLayer

func _ready() -> void:
	self.hide()

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func game_over() -> void:
	self.show()
	get_tree().paused = true


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/mainmenu.tscn")
