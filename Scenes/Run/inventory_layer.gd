extends CanvasLayer

@onready var inventory_view: InventoryView = %InventoryView


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("bag_button"):
		inventory_view.visible = !inventory_view.visible
		inventory_view.inventory.initialize_inventory()
