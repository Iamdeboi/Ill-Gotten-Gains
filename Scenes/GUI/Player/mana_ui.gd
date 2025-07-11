class_name ManaUI
extends HBoxContainer


@export var show_max_mana: bool

@onready var mana_label: Label = %ManaLabel
@onready var max_mana_label: Label = %MaxManaLabel
@onready var mana_image: TextureRect = %ManaImage


func update_stats(stats: BaseStats) -> void:
	mana_label.text = str(stats.mana)
	max_mana_label.text = "/%s" % str(stats.max_mana)
	max_mana_label.visible = show_max_mana
	mana_label.visible = stats.mana > 0
	mana_image.visible = mana_label.visible
	max_mana_label.visible = mana_label.visible
