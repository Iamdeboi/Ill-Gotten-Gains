class_name PlayerStatsUI
extends Control

@onready var portrait: TextureRect = %Portrait
@onready var gui_corner_buttons: GUICornerButtons = %GUICornerButtons
@onready var gui_corner_bars: GUICornerBars = %GUICornerBars
@onready var gui_armor_label: ArmorLabel = %GUIArmorLabel




func update_corner_bars(stats: PlayerStats) -> void:
	gui_corner_bars.update_health_bar(stats)
	gui_corner_bars.update_mana_bar(stats)


func update_armor_label(stats: PlayerStats) -> void:
	gui_armor_label.update_armor_label(stats)


func update_portrait(stats: PlayerStats) -> void:
	portrait.texture = stats.sprite
