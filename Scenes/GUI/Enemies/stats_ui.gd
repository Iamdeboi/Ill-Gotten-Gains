class_name StatsUI
extends HBoxContainer

@onready var armor: HBoxContainer = $Armor
@onready var armor_image: TextureRect = %ArmorImage
@onready var armor_label: Label = %ArmorLabel
@onready var health: HealthUI = $Health
@onready var mana: ManaUI = $Mana



func update_stats(stats: BaseStats) -> void:
	armor_label.text = str(stats.armor)
	health.update_stats(stats)
	mana.update_stats(stats)

	armor_label.visible = stats.armor > 0
	armor_image.visible = armor_label.visible
