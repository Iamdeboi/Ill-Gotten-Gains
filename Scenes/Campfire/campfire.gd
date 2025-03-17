class_name Campfire
extends Control


func _on_button_pressed() -> void:
	EventBus.campfire_exited.emit()
