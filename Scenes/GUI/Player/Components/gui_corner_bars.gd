class_name GUICornerBars
extends Control

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar


func set_health_bar(stats: PlayerStats) -> void:
	health_bar.max_value = stats.max_health
	health_bar.value = stats.health


func set_mana_bar(stats: PlayerStats) -> void:
	mana_bar.max_value = stats.max_mana
	mana_bar.value = stats.mana


func update_health_bar(stats: PlayerStats) -> void:
	health_bar.max_value = stats.max_health
	health_bar.value = stats.health


func update_mana_bar(stats: PlayerStats) -> void:
	mana_bar.max_value = stats.max_mana
	mana_bar.value = stats.mana
