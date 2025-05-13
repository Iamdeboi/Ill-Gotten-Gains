class_name InvSlot
extends Panel

const DEFAULT_THEME = preload("res://Assets/Themes/GUI_Theme.theme")
const EMPTY_THEME = preload("res://Assets/Themes/GUI_Theme_2.theme")

var default_style: Theme = null
var empty_style: Theme = null

var item_scene = preload("res://Scenes/GUI/Inventory/item.tscn")
var item: Item = null # variable of item currently in the slot
var slot_index

func _ready() -> void:
	default_style = DEFAULT_THEME
	empty_style = EMPTY_THEME
	
	#if randi() % 2 == 0:
		#item = item_scene.instantiate()
		#add_child(item)
	refresh_style()


func refresh_style() -> void: # Updates the item slot's style between containing an item (default) or being empty
	if item == null:
		set("theme", empty_style)
	else:
		set("theme", default_style)


func remove_from_slot() -> void: # Take out an item from a slot, refresh tile style
	remove_child(item)
	var inventory_node = find_parent("Inventory")
	inventory_node.add_child(item)
	item = null
	refresh_style()


func add_to_slot(new_item: Item) -> void: # Put in an item into a slot, reposition it properly, refresh tile style
	item = new_item
	item.position = Vector2(0, 0)
	var inventory_node = find_parent("Inventory")
	inventory_node.remove_child(item)
	add_child(item)
	refresh_style()


func initialize_item(item_name, item_quantity) -> void: # Allows for a per-slot conifguration of items during runtime
	if item == null:
		item = item_scene.instantiate()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()
