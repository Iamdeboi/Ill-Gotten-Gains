class_name ActionPointUI
extends Control

@export var player_stats: PlayerStats : set = _set_player_stats

@onready var action_point_label: Label = %ActionPointLabel


func _set_player_stats(value: PlayerStats) -> void:
	player_stats = value
	
	if not player_stats.stats_changed.is_connected(_on_stats_changed):
		player_stats.stats_changed.connect(_on_stats_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stats_changed()


func _on_stats_changed() -> void:
	action_point_label.text = "%s/%s" % [player_stats.action_points, player_stats.maximum_action_points]
