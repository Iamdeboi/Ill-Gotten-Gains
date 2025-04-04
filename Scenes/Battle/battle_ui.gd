class_name BattleUI
extends CanvasLayer

@export var player_stats: PlayerStats: set = _set_player_stats

@onready var ability_container: AbilityContainer = $AbilityContainer as AbilityContainer
@onready var action_point_ui: ActionPointUI = $ActionPointUI as ActionPointUI
@onready var end_turn_button: TextureButton = %EndTurnButton


func _ready() -> void:
	EventBus.player_hotbar_loaded.connect(_on_hotbar_loaded)
	EventBus.player_turn_started.connect(_on_player_turn_started)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)


func _set_player_stats(value: PlayerStats) -> void:
	player_stats = value
	action_point_ui.stats = player_stats
	ability_container.player_stats = player_stats


func _on_hotbar_loaded() -> void:
	end_turn_button.disabled = false


func _on_player_turn_started() -> void:
	end_turn_button.disabled = false


func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	EventBus.player_turn_ended.emit()
