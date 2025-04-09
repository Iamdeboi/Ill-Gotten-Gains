extends Ability


func update_tooltip(stats: PlayerStats) -> String:
	tooltip_text = "Slash your enemy, dealing " + "[color=firebrick]" + str(int(5 + (stats.strength) * ps_factor)) + "[/color]" + " neutral damage.\n\nAbility Type: [color=firebrick]Attack[/color]\nCost: None\nBase: 5\nScaling: (50% STR)"
	return str(tooltip_text)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 5
	damage_effect.sound = sound
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
