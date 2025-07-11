class_name PlayerStatsUI
extends Control

@export var stat_ref: PlayerStats : set = _set_player_stats

@onready var portrait: TextureRect = %Portrait
@onready var spellbook_view: AbilityMenuView = %SpellbookView

@onready var gui_corner_bars: GUICornerBars = %GUICornerBars
@onready var gui_armor_label: ArmorLabel = %GUIArmorLabel
@onready var attribute_window: AttributeWindow = %AttributeWindow


func _ready() -> void:
	pass

func _set_player_stats(value: PlayerStats) -> void:
	stat_ref = value
	update_stats(stat_ref)


func update_ability_view_ui(stats: PlayerStats) -> void:
	#gui_corner_buttons.spellbook_button.ability_list = stats.known_abilities
	spellbook_view.ability_list = stats.known_abilities


func update_stats(stats: PlayerStats) -> void:
	portrait.texture = stats.sprite
	gui_corner_bars.health_bar.max_value = int(stats.max_health)
	gui_corner_bars.health_bar.value = int(stats.health)
	gui_corner_bars.mana_bar.max_value = int(stats.max_mana)
	gui_corner_bars.mana_bar.value = int(stats.mana)
	# gui_corner_buttons.spellbook_button.ability_list = stats.known_abilities
	spellbook_view.ability_list = stats.known_abilities
	gui_armor_label.armor_label.text = str(stats.armor)
	attribute_window.update_attribute_window_ui(stats)
	update_ability_view_ui(stats)
