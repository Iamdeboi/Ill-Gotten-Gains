class_name Enemy
extends Node2D

const ARROW_OFFSET := 5

# Statblock + Assets + StatsUI
@export var stats: BaseStats : set = set_stats

@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var stats_ui: StatsUI = $StatsUI
@onready var target_arrow: Sprite2D = %TargetArrow


func set_stats(value: BaseStats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_enemy()


func update_enemy() -> void:
	if not stats is BaseStats:
		return
	if not is_inside_tree():
		await ready
	
	enemy_sprite.texture = stats.sprite
	update_stats()


func update_stats() -> void:
	stats_ui.update_stats(stats)


func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
		
	stats.take_damage(damage)

	if stats.health <= 0:
		queue_free()


func _on_area_entered(_area: Area2D) -> void:
	target_arrow.show()


func _on_area_exited(_area: Area2D) -> void:
	target_arrow.hide()
