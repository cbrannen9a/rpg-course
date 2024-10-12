extends Node

enum state_types {ACTIVE, DYING, MELEE, RANGED}
var move_state_types = [state_types.ACTIVE, state_types.MELEE, state_types.RANGED]

var items := {
 0: preload("res://scenes/inventory/items/bow.tres"),
 1: preload("res://scenes/inventory/items/dagger.tres"),
 2: preload("res://scenes/inventory/items/potion.tres"),
 3: preload("res://scenes/inventory/items/sword.tres")
}

var item_equipped: ItemData = preload("res://scenes/inventory/items/sword.tres")