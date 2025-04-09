extends Ability


func update_tooltip(stats: PlayerStats) -> String:
	tooltip_text = "Whack an enemy on the head, dealing " + "[color=firebrick]" + str(int(15 + (stats.strength) * ps_factor)) + "[/color]" + " [color=slate_gray]Physical[/color] damage and inflicting 2 Weakness.\n\nAbility Type: [color=firebrick]Attack[/color]\nCost: [color=salmon]10 HP[/color]\nBase: 15\nScaling: (50% STR)"
	return str(tooltip_text)

func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float) -> void:
	var damage_effect = DamageEffect.new()
	damage_effect.amount = 15
	damage_effect.sound = sound
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
