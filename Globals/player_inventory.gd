extends Node

const NUM_INV_SLOTS = 30
const ITEM_SCENE = preload("res://Scenes/GUI/Inventory/item.tscn")
const INV_SLOT = preload("res://Scenes/GUI/Inventory/inv_slot.gd")

var inventory = {
	0: ["Iron Sword", 1], # slot_index: [item_name, item_quantity]
	1: ["Iron Buckler", 1],
	2: ["Weak Mana Potion", 5],
	3: ["Weak Mana Potion", 4],
	4: ["Weak Mana Potion", 3],
	5: ["Weak Mana Potion", 2],
	6: ["Iron Buckler", 1],
	29: ["Weak Mana Potion", 1],
}


func add_item(item_name: String, item_quantity: int): # To use: PlayerInventory.add_item(item_name: String, item_quantity: int) anywhere necessary in the game!
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["stack_size"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity = item_quantity - able_to_add
	
	# If the item doesnt exist in the inventory yet, add it to the next availible empty slot
	for i in range(NUM_INV_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity] # Assign the slot the item's name and quantity values
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return


func update_slot_visual(slot_index, item_name, new_quantity) -> void:
	var slot = get_tree().root.get_node("/root/Run/InventoryLayer/InventoryView/Inventory/TextureRect/MarginContainer/HBoxContainer/InventorySlots/InvSlot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)


func add_item_to_empty_slot(item: Item, slot: InvSlot): # Add to item dictionary
	inventory[slot.slot_index] = [item.item_name, item.item_quantity]


func add_one_item_to_empty_slot(item: Item, slot: InvSlot):
	inventory[slot.slot_index] = [item.item_name, 1]


func remove_item(slot: InvSlot): # Delete from item dictionary
	inventory.erase(slot.slot_index)

func increase_item_quantity(slot: InvSlot, quantity_to_add: int):
	inventory[slot.slot_index][1] += quantity_to_add #In the inventory, at the given slot's 2nd value (the quantity), increase it by the passed "quantity_to_add" integer
