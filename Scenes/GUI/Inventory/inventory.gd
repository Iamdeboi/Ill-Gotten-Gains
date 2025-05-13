class_name Inventory
extends Node2D


const INV_SLOT = preload("res://Scenes/GUI/Inventory/inv_slot.gd")

@onready var inventory_slots: GridContainer = %InventorySlots

var held_item = null


func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size / 2) # Set to center of scren, regardless of resolution
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].gui_input.connect(slot_gui_input.bind(slots[i]))
		slots[i].slot_index = i # Save the index of the slots here
	initialize_inventory()


func initialize_inventory(): # Iterates through all inv_slots, searches through the PlayerInventory global script to add the item
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])


func slot_gui_input(event: InputEvent, slot: InvSlot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if held_item != null: # If holding an item...
				if !slot.item: # Place held item into enpty slot
					place_into_empty_slot(slot)
				elif held_item.item_name != slot.item.item_name: # Else if the item is different, swap places:
						swap_held_item_with_different_item(event, slot)
				else: # Lastly, if the held item is the same as the item in the clicked slot, attempt to combine their stack_sizes
					stack_same_item(slot)
			elif slot.item: # Else, if you are not holding an item when clicking on a slot with an item...
				pick_up_slot_item(slot)


func _input(event: InputEvent) -> void: # Update the item's dictionary here
	if held_item:
		held_item.global_position = get_global_mouse_position()


func place_into_empty_slot(slot: InvSlot):
	PlayerInventory.add_item_to_empty_slot(held_item, slot)
	slot.add_to_slot(held_item)
	held_item = null


func swap_held_item_with_different_item(event: InputEvent, slot: InvSlot):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(held_item, slot)
	var temp_item = slot.item
	slot.remove_from_slot()
	temp_item.global_position = event.global_position
	slot.add_to_slot(held_item)
	held_item = temp_item


func stack_same_item(slot: InvSlot):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["stack_size"]) # Connects the slot item's name in its scene with the JSONData's "stack_size" value in the dictionary
	var quantity_stackable = stack_size - slot.item.item_quantity
	if quantity_stackable >= held_item.item_quantity: # If there is still more room on the item's stack_size after merge attempt...ty
		PlayerInventory.increase_item_quantity(slot, held_item.item_quantity)
		slot.item.add_item_quantity(held_item.item_quantity)
		held_item.queue_free()
		held_item = null
	else: # Else, add up to the stack_size of the item, and reduce the same number from the held item's quantity
		PlayerInventory.increase_item_quantity(slot, quantity_stackable)
		slot.item.add_item_quantity(quantity_stackable)
		held_item.decrease_item_quantity(quantity_stackable)


func pick_up_slot_item(slot: InvSlot):
	PlayerInventory.remove_item(slot)
	held_item = slot.item
	slot.remove_from_slot()
	held_item.global_position = get_global_mouse_position()
