class_name MainMenu
extends Control


@onready var start_level = preload("res://Scenes/Battle/battle_scene.tscn")
const CHAR_SELECT_SCENE := preload("res://Scenes/Menus/character_selection.tscn")

func _ready() -> void:
	get_tree().paused = false


func _on_continue_button_click_end() -> void:
	get_tree().change_scene_to_packed(start_level)
	print("TODO: Incorporate save file(s) system to play games from saved points of the game")


func _on_new_run_button_click_end() -> void:
	get_tree().change_scene_to_packed(CHAR_SELECT_SCENE)


func _on_exit_button_click_end() -> void:
	get_tree().quit()
