class_name ResourceCount
extends Control

@onready var hp_count: Label = %HPCount
@onready var mp_count: Label = %MPCount
@onready var max_hp_count: Label = %MaxHPCount
@onready var max_mp_count: Label = %MaxMPCount


func update_resource_count_ui(stats: PlayerStats):
	hp_count.text = str(stats.health)
	mp_count.text = str(stats.mana)
	max_hp_count.text = str(stats.max_health)
	max_mp_count.text = str(stats.max_mana)
