extends Ability

var base_damage := 15


func update_tooltip(stats: PlayerStats) -> String:
	tooltip_text = "Carve through all enemies, dealing " + "[color=firebrick]" + str(int(20 + (stats.strength) * ps_factor)) +"[/color]" + " [color=slate_gray]Physical[/color] damage to all targets.\n\nAbility Type: [color=firebrick]Attack[/color]\nCost: [color=salmon]10 HP[/color]\nBase: 20\nScaling: (150% STR)"
	return str(tooltip_text)

func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
