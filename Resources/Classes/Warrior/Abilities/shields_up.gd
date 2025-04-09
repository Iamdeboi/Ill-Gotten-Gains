extends Ability



func update_tooltip(stats: PlayerStats) -> String:
	tooltip_text = "Raise your shield, increasing armor by " + "[color=blue]" + str(int(10 + (stats.constitution * ps_factor))) + "[/color]" + ". \n\nAbility Type: [color=blue]Defense[/color]\nCost: None\nBase: 10\nScaling: (50% CON)"
	return str(tooltip_text)

func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float) -> void:
	var armor_effect := ArmorEffect.new()
	armor_effect.amount = 10
	armor_effect.sound = sound
	armor_effect.execute(targets, ability, p_s_mod, s_s_mod)
