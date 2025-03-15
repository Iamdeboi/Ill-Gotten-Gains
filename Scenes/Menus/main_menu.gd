class_name MainMenu
extends Control


@onready var start_level = preload("res://Scenes/Combat/battle_scene.tscn")
@onready var character_select_screen = preload("res://Scenes/Menus/character_selection.tscn")


func _on_continue_button_click_end() -> void:
	get_tree().change_scene_to_packed(start_level)


func _on_new_run_button_click_end() -> void:
	get_tree().change_scene_to_packed(character_select_screen)


func _on_exit_button_click_end() -> void:
	get_tree().quit()
