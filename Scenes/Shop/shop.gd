class_name Shop
extends Control



func _on_button_pressed() -> void:
	EventBus.shop_exited.emit()
