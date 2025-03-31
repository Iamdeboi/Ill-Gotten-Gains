class_name PlayerStatsUI
extends Control

@onready var portrait: TextureRect = %Portrait
@onready var gui_corner_buttons: GUICornerButtons = %GUICornerButtons
@onready var gui_corner_bars: GUICornerBars = %GUICornerBars
@onready var gui_armor_label: ArmorLabel = %GUIArmorLabel
@onready var attribute_window: AttributeWindow = %AttributeWindow


func update_stats(stats: PlayerStats) -> void:
	portrait.texture = stats.sprite
	gui_corner_bars.health_bar.max_value = stats.max_health
	gui_corner_bars.health_bar.value = stats.health
	gui_corner_bars.mana_bar.max_value = stats.max_mana
	gui_corner_bars.mana_bar.value = stats.mana
	gui_armor_label.armor_label.text = str(stats.armor)
	attribute_window.update_attribute_window_ui(stats)
