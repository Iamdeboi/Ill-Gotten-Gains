class_name AttributeWindow
extends Control

@onready var str_count: Label = %STRCount
@onready var dex_count: Label = %DEXCount
@onready var int_count: Label = %INTCount
@onready var wis_count: Label = %WISCount
@onready var cha_count: Label = %CHACount
@onready var con_count: Label = %CONCount


func update_attribute_window_ui(stats: PlayerStats) -> void:
	str_count.text = str(stats.strength)
	dex_count.text = str(stats.dexterity)
	int_count.text = str(stats.intellect)
	wis_count.text = str(stats.wisdom)
	cha_count.text = str(stats.charisma)
	con_count.text = str(stats.constitution)
