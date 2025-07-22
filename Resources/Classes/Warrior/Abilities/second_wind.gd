extends Ability


var base_healing := 15


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(stats: PlayerStats, player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var pre_mod_healing = base_healing + (player_modifiers.get_modified_value(stats.base_strength, Modifier.Type.STR_MOD)) * (ps_factor)
	pre_mod_healing += (player_modifiers.get_modified_value(stats.base_constitution, Modifier.Type.CON_MOD) * (ss_factor))
	var final_mod_healing = int(pre_mod_healing)
	var updated_tooltip = "Catch your breath, restoring " + "[color=salmon]" + str(final_mod_healing) + "[/color]" + " health.\n\nAbility Type: [color=lime_green]Buff[/color]\nTargets: Self\nCost: [color=cyan]5 MP[/color]\nBase: 15\nScaling: (50% STR) + (50% CON)"
	return str(updated_tooltip)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  _modifiers: ModifierHandler) -> void:
	# Healing Component
	var healing_effect := HealingEffect.new()
	healing_effect.amount = int(base_healing + p_s_mod + s_s_mod) # base_healing + 50% STR + %50 CON
	healing_effect.sound = sound
	healing_effect.execute(targets, ability, p_s_mod, s_s_mod)
