class_name Player
extends Control


const WHITE_SPRITE_MATERIAL := preload("res://Assets/art/white_sprite_material.tres")
const RED_SPRITE_MATERIAL :=preload("res://Assets/art/red_sprite_material.tres")
# PlayerStats (Player Class Stat Block)
@export var stats: PlayerStats : set = set_player_stats #Attach the statblock resource
# GUI Collection
@onready var player_stats_ui: PlayerStatsUI = $PlayerStatsUI
# Status and Modifier Handler Nodes
@onready var status_handler: StatusHandler = $StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler


func _ready() -> void:
	status_handler.status_owner = self


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
	await count_attribute_modifiers()
	player_stats_ui.update_stats(stats)


func count_attribute_modifiers() -> void:
	stats.strength = modifier_handler.get_modified_value(stats.base_strength, Modifier.Type.STR_MOD)
	stats.dexterity = modifier_handler.get_modified_value(stats.base_dexterity, Modifier.Type.DEX_MOD)
	stats.intellect = modifier_handler.get_modified_value(stats.base_intellect, Modifier.Type.INT_MOD)
	stats.wisdom = modifier_handler.get_modified_value(stats.base_wisdom, Modifier.Type.WIS_MOD)
	stats.charisma = modifier_handler.get_modified_value(stats.base_charisma, Modifier.Type.CHA_MOD)
	stats.constitution = modifier_handler.get_modified_value(stats.base_constitution, Modifier.Type.CON_MOD)


func take_damage(damage: int, which_modifier: Modifier.Type) -> void:
	if stats.health <= 0:
		return
		
	if stats.armor <= damage: # Damage will reduce health
		player_stats_ui.portrait.material = RED_SPRITE_MATERIAL
	else: # Armor will block damage before reducing health
		player_stats_ui.portrait.material = WHITE_SPRITE_MATERIAL
	
	var modified_damage := modifier_handler.get_modified_value(damage, which_modifier)
	var tween := create_tween()
	tween.tween_callback(Shaker.control_node_shake.bind(player_stats_ui.portrait, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage))
	tween.tween_interval(0.15)
	
	tween.finished.connect(
		func():
			player_stats_ui.portrait.material = null
			
			if stats.health <= 0:
				EventBus.player_died.emit()
	)


func calculate_damage(amount: int, dmg_mod: float, primary_scaling_mod: float, secondary_scaling_mod: float) -> int:
	return stats.calculate_damage(amount, dmg_mod, primary_scaling_mod, secondary_scaling_mod)


func heal(amount: int) -> void:
	if stats.health >= stats.max_health:
		return
	
	stats.heal(amount)
