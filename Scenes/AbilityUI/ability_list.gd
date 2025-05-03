class_name AbilityList
extends Resource
# Container resource for any and all arrays of abilities
# This should be used for the creation of ability_slots (ability ui scenes) in code

signal ability_list_size_changed(ability_amount)

@export var abilities: Array[Ability] = []

func empty() -> bool:
	return abilities.is_empty()


func place_ability_slot() -> Ability:
	var ability = abilities.pop_front()
	ability_list_size_changed.emit(abilities.size())
	return ability


func add_ability(ability: Ability):
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
