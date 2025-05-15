extends Node

const NUM_INV_SLOTS = 30

# The data references for the inventory items are stored here
var inventory = []

# Run Scene Dependency + Inventory Slot Scene Ref
var run_node: Node = null
@onready var inventory_slot_scene = preload("res://Scenes/GUI/Inventory/inv_slot.tscn")

func _ready() -> void:
	inventory.resize(NUM_INV_SLOTS)

# Adds item to inventory, returns true or false depending on success
func add_item(item): # TODO: Implement stack_size clause here, it should be similar to the elif statement here, adding the item to the next available slot
	for i in range(inventory.size()):
		# Check for existence of item in the inventory, and that it matches both its type and effect
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			EventBus.inventory_changed.emit()
			print("Item added", inventory)
			return true
		elif inventory[i] == null:
			inventory[i] = item
			EventBus.inventory_changed.emit()
			print("Item added", inventory)
			return true
	return false

# Removes item from inventory, returns true or false depending on success
func remove_item(item_type, item_effect): 
	for i in range(inventory.size()):
		# Check for existence of item in the inventory, and that it matches both its type and effect
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			EventBus.inventory_changed.emit()
			return true
	return false


func increase_inventory_size(extra_slots):
	inventory.resize(inventory.size() + extra_slots)
	EventBus.inventory_changed.emit()


# Sets up the reference to the run_scene at the start of a game, includes the player data within it
func set_run_reference(run_ref: Node):
	run_node = run_ref
