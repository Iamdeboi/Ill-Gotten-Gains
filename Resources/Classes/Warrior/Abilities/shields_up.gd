extends Ability


func apply_effects(targets: Array[Node], ability: Ability, primary_scaling_mod: float, secondary_scaling_mod: float) -> void:
	var armor_effect := ArmorEffect.new()
	armor_effect.amount = 10
	armor_effect.execute(targets, ability, primary_scaling_mod, secondary_scaling_mod)
