class_name ArmorLabel
extends Control

@onready var armor_label: Label = %ArmorLabel


func set_armor(stats: PlayerStats) -> void:
	armor_label.text = str(stats.armor)
	update_armor_label(stats)

func update_armor_label(stats: PlayerStats) -> void:
	armor_label.text = str(stats.armor)
