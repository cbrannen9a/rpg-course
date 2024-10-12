extends Control

var items_to_load: Array = [
  "res://scenes/inventory/items/bow.tres",
  "res://scenes/inventory/items/dagger.tres",
  "res://scenes/inventory/items/potion.tres",
  "res://scenes/inventory/items/sword.tres"
]

@export var inventory_size: int = 9
@onready var grid = get_node("Grid")
func _ready() -> void:
  for i in inventory_size:
    var slot = InventorySlot.new()
    slot.init(ItemData.Type.MAIN, Vector2(32, 32))
    grid.add_child(slot)
  for i in items_to_load.size():
    var item = InventoryItem.new()
    item.init(load(items_to_load[i]))
    grid.get_child(i).add_child(item)

func add_item(item_num: int) -> void:
  var item = InventoryItem.new()
  item.init(Global.items[item_num])
  if item.data.stackable:
    for i in inventory_size:
      if grid.get_child(i).get_child_count() > 0:
        if grid.get_child(i).get_child(0).data == item.data:
          #add to data count
          grid.get_child(i).get_child(0).data.count += 1
          #update the label counter
          grid.get_child(i).get_child(0).get_child(0).text = str(grid.get_child(i).get_child(0).data.count)
          break
      else:
        grid.get_child(i).add_child(item)
  else:
    for i in inventory_size:
      if grid.get_child(i).get_child_count() == 0:
        grid.get_child(i).add_child(item)
