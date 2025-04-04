extends Ability


func apply_effects(targets: Array[Node], ability: Ability) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 20
	damage_effect.execute(targets, ability)
