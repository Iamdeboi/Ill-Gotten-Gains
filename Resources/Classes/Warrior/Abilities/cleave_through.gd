extends Ability


func apply_effects(targets: Array[Node], ability: Ability, primary_scaling_mod: float, secondary_scaling_mod: float) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 20
	damage_effect.execute(targets, ability, primary_scaling_mod, secondary_scaling_mod)
