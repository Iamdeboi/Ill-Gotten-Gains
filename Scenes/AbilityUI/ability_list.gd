class_name AbilityList
extends Resource

signal ability_list_size_changed(ability_amount)

@export var abilities : Array[Ability] = []

func empty() -> bool:
	return abilities.is_empty()


func add_abillity(ability: Ability):
	abilities.append(ability)
	ability_list_size_changed.emit(abilities.size())


func clear() -> void:
	abilities.clear()
	ability_list_size_changed.emit(abilities.size())


func _to_string() -> String:
	var _ability_strings : PackedStringArray = []
	for i in range(abilities.size()):
		_ability_strings.append("%s: %s" % [i+1, abilities[i].id])
	return "\n".join(_ability_strings) 
