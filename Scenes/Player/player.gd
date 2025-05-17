class_name Player
extends Control


const WHITE_SPRITE_MATERIAL := preload("res://Assets/art/white_sprite_material.tres")
const RED_SPRITE_MATERIAL :=preload("res://Assets/art/red_sprite_material.tres")
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
		
	if stats.armor <= damage: # Damage will reduce health
		player_stats_ui.portrait.material = RED_SPRITE_MATERIAL
	else: # Armor will block damage before reducing health
		player_stats_ui.portrait.material = WHITE_SPRITE_MATERIAL
		
	var tween := create_tween()
	tween.tween_callback(Shaker.control_node_shake.bind(player_stats_ui.portrait, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.15)
	
	tween.finished.connect(
		func():
			player_stats_ui.portrait.material = null
			
			if stats.health <= 0:
				EventBus.player_died.emit()
				await get_tree().create_timer(0.05).timeout
				queue_free()
	)


func calculate_damage(amount: int, dmg_mod: float, primary_scaling_mod: float, secondary_scaling_mod: float) -> int:
	return stats.calculate_damage(amount, dmg_mod, primary_scaling_mod, secondary_scaling_mod)


func heal(amount: int) -> void:
	if stats.health >= stats.max_health:
		return
	
	stats.heal(amount)
