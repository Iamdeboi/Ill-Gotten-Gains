extends Ability


var base_damage := 5

func update_tooltip(stats: PlayerStats) -> String:
	tooltip_text = "Slash your enemy, dealing " + "[color=firebrick]" + str(int(5 + (stats.base_strength) * ps_factor)) + "[/color]" + " neutral damage.\n\nAbility Type: [color=firebrick]Attack[/color]\nCost: None\nBase: 5\nScaling: (50% STR)"
	return str(tooltip_text)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float, modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage ,Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
