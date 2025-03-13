class_name Player
extends Node

#Statblocks
@export var stats: PlayerStats : set = set_player_stats #Attach the statblock resource
# GUI Collection
@onready var player_stats_ui: PlayerStatsUI = $PlayerStatsUI

func set_player_stats(value: PlayerStats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()


func update_player() -> void:
	if not stats is PlayerStats:
		return
	if not is_inside_tree():
		await ready
	
	update_stats()


func update_stats() -> void:
	player_stats_ui.update_corner_bars(stats)
	player_stats_ui.update_armor_label(stats)
	player_stats_ui.update_portrait(stats)


func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
		
	stats.take_damage(damage)

	if stats.health <= 0:
		queue_free()
