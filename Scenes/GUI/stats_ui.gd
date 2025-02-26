class_name StatsUI
extends HBoxContainer

@onready var armor: HBoxContainer = $Armor
@onready var armor_label: Label = %ArmorLabel
@onready var health: HBoxContainer = $Health
@onready var health_label: Label = %HealthLabel


func update_stats(stats: Stats) -> void:
	armor_label.text = str(stats.armor)
	health_label.text = str(stats.health)
	
	armor.visible = stats.armor > 0
	health.visible = stats.health > 0
