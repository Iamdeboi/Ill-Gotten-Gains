class_name PlayerStatsUI
extends Control

@onready var gui_corner_buttons: GUICornerButtons = %GUICornerButtons
@onready var gui_corner_bars: Control = %GUICornerBars
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar
@onready var gui_armor_label: Control = %GUIArmorLabel
@onready var armor_label: Label = %ArmorLabel





func update_corner_bars(stats: BaseStats) -> void:
	if health_bar.max_value != stats.max_health:
		health_bar.max_value = stats.max_health
	health_bar.value = stats.health

	if mana_bar.max_value != stats.max_mana:
		mana_bar.max_value = stats.max_mana
	mana_bar.value = stats.mana



func update_armor_label(stats: BaseStats) -> void:
	armor_label.text = str(stats.armor)
