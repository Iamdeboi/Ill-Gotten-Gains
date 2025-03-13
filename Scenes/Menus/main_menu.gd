class_name MainMenu
extends Control


@onready var start_level = preload("res://Scenes/Combat/battle_scene.tscn")


func _on_start_button_click_end() -> void:
	get_tree().change_scene_to_packed(start_level)


func _on_exit_button_click_end() -> void:
	get_tree().quit()
