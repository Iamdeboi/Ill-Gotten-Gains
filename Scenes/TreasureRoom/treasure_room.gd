class_name TreasureRoom
extends Control


func _on_button_pressed() -> void:
	EventBus.treasure_room_exited.emit()
