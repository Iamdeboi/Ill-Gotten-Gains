extends Ability


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 5
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
