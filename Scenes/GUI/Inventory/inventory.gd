class_name Inventory
extends Node2D


const INV_SLOT = preload("res://Scenes/GUI/Inventory/inv_slot.gd")

@onready var inventory_slots: GridContainer = %InventorySlots

var held_item = null


func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size / 2) # Set to center of scren, regardless of resolution
	for inv_slot in inventory_slots.get_children():
		inv_slot.gui_input.connect(slot_gui_input.bind(inv_slot))


func slot_gui_input(event: InputEvent, slot: InvSlot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if held_item != null: # If holding an item...
				if !slot.item: # Place held item into enpty slot
					slot.add_to_slot(held_item)
					held_item = null
				else:
					if held_item.item_name != slot.item.item_name: # Confims if the item is different, and swaps places 
						var temp_item = slot.item
						slot.remove_from_slot()
						temp_item.global_position = event.global_position
						slot.add_to_slot(held_item)
						held_item = temp_item
					else: # Else, the item is the same, and if stackable, attempt to stack together
						var stack_size = int(JsonData.item_data[slot.item.item_name]["stack_size"]) # Connects the slot item's name in its scene with the JSONData's "stack_size" value in the dictionary
						var quantity_stackable = stack_size - slot.item.item_quantity
						if quantity_stackable >= held_item.item_quantity: # If there is still more room on the item's stack_size after merge attempt...
							slot.item.add_item_quantity(held_item.item_quantity)
							held_item.queue_free()
							held_item = null
						else: # Else, add up to the stack_size of the item, and reduce the same number from the held item's quantity
							slot.item.add_item_quantity(quantity_stackable)
							held_item.decrease_item_quantity(quantity_stackable)
			elif slot.item: # Else, if you are not holding an item when clicking on a slot with an item...
				held_item = slot.item
				slot.remove_from_slot()
				held_item.global_position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if held_item:
		held_item.global_position = get_global_mouse_position()
