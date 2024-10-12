class_name InventorySlot
extends PanelContainer

@export var type: ItemData.Type
var equipped: bool = false

func init(t: ItemData.Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is InventoryItem:
		if type == ItemData.Type.MAIN:
			if get_child_count() == 0:
				return true
			else:
				if type == data.get_parent():
					return true
				return get_child(0).data.type == data.data.type
		else:
			return data.data.type == type
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		item.reparent(data.get_parent())
	data.reparent(self)
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == 1) and (event.button_mask == 1):
			if get_child_count() > 0:
				if (get_child(0).data.type == ItemData.Type.MISC):
					var player = get_tree().get_nodes_in_group("player")[0]
					player.health += get_child(0).data.item_health
					get_child(0).data.count -= 1
					get_child(0).get_child(0).text = str(get_child(0).data.count)
					if get_child(0).data.count <= 0:
						get_child(0).queue_free()
				else:
					Global.item_equipped = get_child(0).data
