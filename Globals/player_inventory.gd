extends Node
# A globbally available container for the player's inventoy data. Used in the inventory GUI, also tied to the run scene

const NUM_INV_SLOTS = 30
const PLAYER_INVENTORY_DATA: InventoryData = preload("res://Scenes/GUI/Inventory/player_inventory.tres")

# Run Scene Dependency + Inventory Slot Scene Ref
var run_node: Node : set = _set_run_reference

@onready var inventory_slot_scene = preload("res://Scenes/GUI/Inventory/inv_slot.tscn")

func _ready() -> void:
	if PLAYER_INVENTORY_DATA:
		print("Data ready to go!")
	

# Sets up the reference to the run_scene at the start of a game, includes the player data within it
func _set_run_reference(run_ref: Run):
	run_node = run_ref
	print("run_node loaded")
