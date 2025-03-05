class_name StatsUI
extends HBoxContainer

@onready var armor: HBoxContainer = $Armor
@onready var armor_label: Label = %ArmorLabel
@onready var health: HBoxContainer = $Health
@onready var health_label: Label = %HealthLabel


func update_health(stats: BaseStats) -> void:
	health_label.text = str(stats.health)
	armor_label.text = str(stats.armor)
