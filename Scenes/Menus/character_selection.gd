class_name CharacterSelection
extends Control

const RUN_SCENE := preload("res://Scenes/Run/run.tscn")
const WARRIOR_STATS := preload("res://Resources/Player/warrior_stats.tres")
const WIZARD_STATS := preload("res://Resources/Player/wizard_stats.tres")
const THIEF_STATS := preload("res://Resources/Player/thief_stats.tres")

@export var run_startup : RunStartup

@onready var start_run_button: TextureButton = %StartRunButton

var current_character: PlayerStats : set = set_current_character

func _ready() -> void:
	set_current_character(WARRIOR_STATS)
	start_run_button.disabled = true

func set_current_character(new_character: PlayerStats) -> void:
	current_character = new_character


func _on_start_run_button_click_end() -> void:
	print("Starting new Run with %s" % current_character.name)
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.selected_character = current_character
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_warrior_button_pressed() -> void:
	current_character = WARRIOR_STATS
	start_run_button.disabled = false

func _on_mage_button_pressed() -> void:
	current_character = WIZARD_STATS
	start_run_button.disabled = false

func _on_thief_button_pressed() -> void:
	current_character = THIEF_STATS
	start_run_button.disabled = false
