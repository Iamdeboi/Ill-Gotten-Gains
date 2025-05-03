class_name SpellbookButton
extends TextureButton

@export var ability_list: AbilityList : set = set_ability_list


func set_ability_list(new_value: AbilityList) -> void:
	ability_list = new_value
