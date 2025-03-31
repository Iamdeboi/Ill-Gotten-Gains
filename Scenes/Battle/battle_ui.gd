class_name BattleUI
extends CanvasLayer

@export var player_stats: PlayerStats: set = _set_player_stats

@onready var ability_container: AbilityContainer = $AbilityContainer as AbilityContainer
@onready var action_point_ui: ActionPointUI = $ActionPointUI as ActionPointUI


func _set_player_stats(value: PlayerStats) -> void:
	player_stats = value
	action_point_ui.stats = player_stats
