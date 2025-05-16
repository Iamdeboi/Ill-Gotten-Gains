class_name InventoryData
extends Resource

@export var slots: Array[SlotData]


func add_item(item : ItemData, count : int = 1) -> bool:
	for s in slots:
		if s:
			if s.item_data == item: # If the item exists...
				if s.quantity + count <= item.stack_size:
					s.quantity += count
					print(str(count	) + " " + str(item.item_name) + " added!")
					EventBus.inventory_changed.emit()
					return true

	for i in slots.size():
		if slots[i] == null: #If the slot at this index is empty...
			var new = SlotData.new()
			new.item_data = item
			new.quantity += count
			slots[i] = new
			print("Item added in new slot! You added " + str(count) + " new " + str(item.item_name) + "!")
			EventBus.inventory_changed.emit()
			return true

	print("Inventory is full!")
	return false
