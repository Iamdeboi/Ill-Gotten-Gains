class_name Enemy
extends Node2D

const ARROW_OFFSET := 5

# Statblock + Assets + StatsUI
@export var enemy_stats: BaseStats : set = set_enemy_stats
@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var select_arrow: Sprite2D = $SelectArrow
@onready var stats_ui: StatsUI = $StatsUI


func set_enemy_stats(value: BaseStats) -> void:
	enemy_stats = value.create_instance()
	
	if not enemy_stats.stats_changed.is_connected(update_stats):
		enemy_stats.stats_changed.connect(update_stats)
	
	update_enemy()


func update_enemy() -> void:
	if not enemy_stats is BaseStats:
		return
	if not is_inside_tree():
		await ready
	
	enemy_sprite.texture = enemy_stats.sprite
	select_arrow.position = Vector2.RIGHT * (enemy_sprite.get_rect().size.x / 2 + ARROW_OFFSET)
	update_stats()


func update_stats() -> void:
	stats_ui.update_stats(enemy_stats)


func take_damage(damage: int) -> void:
	if enemy_stats.health <= 0:
		return
		
	enemy_stats.take_damage(damage)

	if enemy_stats.health <= 0:
		queue_free()


func _on_area_entered(_area: Area2D) -> void:
	select_arrow.show()


func _on_area_exited(_area: Area2D) -> void:
	select_arrow.hide()
