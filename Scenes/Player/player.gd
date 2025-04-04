class_name Player
extends Node

#Statblocks
@export var stats: PlayerStats : set = set_player_stats #Attach the statblock resource
# GUI Collection
@onready var player_stats_ui: PlayerStatsUI = $PlayerStatsUI


func set_player_stats(value: PlayerStats) -> void:
	stats = value
	# Connect stats_changed signal to this class's "update_stats" method
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
	player_stats_ui.update_stats(stats)


func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
		
	stats.take_damage(damage)

	if stats.health <= 0:
		queue_free()


func calculate_damage(amount: int, dmg_mod: float, primary_scaling_mod: float, secondary_scaling_mod: float) -> int:
	return stats.calculate_damage(amount, dmg_mod, primary_scaling_mod, secondary_scaling_mod)


func heal(amount: int) -> void:
	if stats.health >= stats.max_health:
		return
	
	stats.heal(amount)
