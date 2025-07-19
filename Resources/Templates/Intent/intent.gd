class_name Intent
extends Resource

@export var base_text: String : set = set_text
@export var icon: Texture

var current_text: String


func set_text(value: String) -> void:
	base_text = value
