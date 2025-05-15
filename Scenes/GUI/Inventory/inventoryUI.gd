class_name InventoryUI
extends Control

const INV_SLOT_MAXIMUM = 30
const INV_SLOT_SCENE = preload("res://Scenes/GUI/Inventory/inv_slot.tscn")

@onready var inventory_slots: GridContainer = %InventorySlots
@onready var equipment_and_desc: VBoxContainer = %EquipmentAndDesc
# Item Data Labels:
@onready var item_name: RichTextLabel = %ItemName
@onready var item_type: Label = %ItemType
@onready var item_description: RichTextLabel = %ItemDescription
@onready var item_effects_or_stats: RichTextLabel = %ItemEffectsOrStats # This shows the changed stats or consumable's effects where applicable
@onready var item_gold_value: RichTextLabel = %ItemGoldValue
@export var data: InventoryData


var held_item = null


func _ready() -> void:
	EventBus.inventory_changed.connect(update_inventory)
	EventBus.item_focused.connect(_on_item_focused)
	EventBus.item_unfocused.connect(_on_item_unfocused)
	self.position = Vector2(get_viewport_rect().size / 2) # Set to center of scren, regardless of resolution
	EventBus.inventory_changed.emit()
	# Clear all text and labels from the start of the scene
	clear_item_labels()

# Instantiate new slots, and assign their respective data relative to the recieved data
func update_inventory() -> void: 
	clear_inventory_slots()
	for s in data.slots:
		var new_slot = INV_SLOT_SCENE.instantiate()
		inventory_slots.add_child(new_slot)
		new_slot.slot_data = s


func clear_inventory_slots() -> void:
	for c in inventory_slots.get_children():
		c.queue_free()


func update_item_labels(reference_slot_data: SlotData) -> void:
	var color_code_header: String
	match reference_slot_data.item_data.item_rarity:
		0: # BASE
			color_code_header = "[color=dim_gray]"
		1: # COMMON
			color_code_header = "[color=white]"
		2: # UNCOMMON
			color_code_header = "[color=lime]"
		3: # RARE
			color_code_header = "[color=royal_blue]"
		4: # EPIC
			color_code_header =  "[color=rebecca_purple]"
		5: # LEGENDARY
			color_code_header = "[color=orange]"
		6: # MYTHIC
			color_code_header = "[color=crimson]"
	
	item_name.text = str(color_code_header + reference_slot_data.item_data.item_name) + "[/color]"
	item_type.text = reference_slot_data.item_data.item_type_string
	item_description.text = reference_slot_data.item_data.item_description
	item_effects_or_stats.text = reference_slot_data.item_data.item_effect
	item_gold_value.text = "Gold Value: [color=gold]" + str(reference_slot_data.item_data.item_gold_value) + "[/color]"



func clear_item_labels() -> void:
	item_name.text = ""
	item_type.text = ""
	item_description.text = ""
	item_effects_or_stats.text = ""
	item_gold_value.text = ""

# When an item is focused on the inventory, update all of the labels to show the details
func _on_item_focused(new_slot_data: SlotData) -> void:
	update_item_labels(new_slot_data)

#When an item is unfocused, clear the existing labels to make room for a new instance of lable data
func _on_item_unfocused() -> void:
	clear_item_labels()
