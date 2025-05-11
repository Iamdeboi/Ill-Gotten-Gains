class_name Inventory
extends Node2D


const INV_SLOT = preload("res://Scenes/GUI/Inventory/inv_slot.gd")

@onready var inventory_slots: GridContainer = %InventorySlots

var held_item = null


func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size / 2) # Set to center of scren, regardless of resolution
	for inv_slot in inventory_slots.get_children():
		inv_slot.gui_input.connect(slot_gui_input.bind(inv_slot))


func slot_gui_input(event: InputEvent, slot: INV_SLOT):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if held_item != null:
				if !slot.item: # Place held item into slot
					slot.add_to_slot(held_item)
					held_item = null
				else: # Swap held item with item in the slot
					var temp_item = slot.item
					slot.remove_from_slot()
					temp_item.global_position = event.global_position
					slot.add_to_slot(held_item)
					held_item = temp_item
			elif slot.item:
				held_item = slot.item
				slot.remove_from_slot()
				held_item.global_position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if held_item:
		held_item.global_position = get_global_mouse_position()
