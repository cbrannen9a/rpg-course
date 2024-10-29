extends Node2D

@onready var monster_scene: PackedScene = preload("res://scenes/cyclops.tscn")


func _ready() -> void:
	for i in range(10):
		var monster_temp = monster_scene.instantiate()
		monster_temp.position = Vector2(randi_range(0, 500), randi_range(0, 500))
		add_child(monster_temp)