extends Ability


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float) -> void:
	var armor_effect := ArmorEffect.new()
	armor_effect.amount = 10
	armor_effect.execute(targets, ability, p_s_mod, s_s_mod)
