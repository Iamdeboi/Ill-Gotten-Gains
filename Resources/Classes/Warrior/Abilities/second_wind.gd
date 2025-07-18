extends Ability


var base_healing := 15


func update_tooltip(stats: PlayerStats) -> String:
	tooltip_text = "Catch your breath, restoring " + "[color=salmon]" + str(int(15 + int((stats.strength) * ps_factor)) + int((stats.constitution) * ss_factor)) + "[/color]" + " health.\n\nAbility Type: [color=lime_green]Buff[/color]\nCost: [color=cyan]5 MP[/color]\nBase: 15\nScaling: (50% STR) + (50% CON)"
	return str(tooltip_text)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  _modifiers: ModifierHandler) -> void:
	var healing_effect := HealingEffect.new()
	healing_effect.amount = base_healing
	healing_effect.sound = sound
	healing_effect.execute(targets, ability, p_s_mod, s_s_mod)
