extends Ability

var base_damage := 15


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(stats: PlayerStats, player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var pre_mod_dmg = base_damage + (player_modifiers.get_modified_value(stats.base_strength, Modifier.Type.STR_MOD) * ps_factor)
	var final_dmg = player_modifiers.get_modified_value(pre_mod_dmg, Modifier.Type.DMG_TAKEN)
	if enemy_modifiers:
		final_dmg = enemy_modifiers.get_modified_value(final_dmg, Modifier.Type.DMG_TAKEN)
	var updated_tooltip = "Carve through all enemies, dealing " + "[color=firebrick]" + str(final_dmg) + "[/color]" + " [color=slate_gray]Physical[/color] damage to all targets.\n\nAbility Type: [color=firebrick]Attack[/color]\nCost: [color=salmon]10 HP[/color]\nBase: 20\nScaling: (150% STR)"
	return str(updated_tooltip)

func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
