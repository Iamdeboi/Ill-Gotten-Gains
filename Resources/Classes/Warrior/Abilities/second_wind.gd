extends Ability


var base_healing := 15


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(stats: PlayerStats, player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var updated_tooltip = "Catch your breath, restoring " + "[color=salmon]" + str(int(base_healing + (player_modifiers.get_modified_value(stats.base_strength, Modifier.Type.STR_MOD) * ps_factor) + int(player_modifiers.get_modified_value(stats.base_strength, Modifier.Type.STR_MOD) * ss_factor))) + "[/color]" + " health.\n\nAbility Type: [color=lime_green]Buff[/color]\nCost: [color=cyan]5 MP[/color]\nBase: 15\nScaling: (50% STR) + (50% CON)"
	return str(updated_tooltip)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  _modifiers: ModifierHandler) -> void:
	var healing_effect := HealingEffect.new()
	healing_effect.amount = base_healing
	healing_effect.sound = sound
	healing_effect.execute(targets, ability, p_s_mod, s_s_mod)
