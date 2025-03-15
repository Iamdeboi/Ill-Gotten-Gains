class_name CharacterSelection
extends Control

@onready var start_button: Button = $Panel2/StartButton

@onready var run_scene = preload("res://Scenes/Run/run.tscn")
@onready var battle_scene = preload("res://Scenes/Combat/battle_scene.tscn")


func _on_button_click_end() -> void:
	get_tree().change_scene_to_packed(battle_scene)
