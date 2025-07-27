extends Ability


var base_damage := 5


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(stats: PlayerStats, player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var pre_mod_dmg = base_damage + (player_modifiers.get_modified_value(stats.base_strength, Modifier.Type.STR_MOD)) * (ps_factor) # Initial Scalings
	var final_dmg = player_modifiers.get_modified_value(pre_mod_dmg, Modifier.Type.DMG_DEALT)
	if enemy_modifiers:
		final_dmg = enemy_modifiers.get_modified_value(final_dmg, Modifier.Type.DMG_TAKEN)
	
	var updated_tooltip = "Slash your enemy, dealing " + "[color=firebrick]" + str(final_dmg) + "[/color]" + " neutral damage.\n\nAbility Type: [color=firebrick]Attack[/color]\nTargets: Single Enemy\nCost: None\nBase: " + str(base_damage) + "\nScaling: (50% STR)"
	return str(updated_tooltip)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float, modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
