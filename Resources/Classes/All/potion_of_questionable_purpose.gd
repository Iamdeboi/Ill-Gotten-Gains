extends Ability


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(_stats: PlayerStats, _player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var updated_tooltip = "[color=crimson]You get the odd feeling that you shouldn't drink this potion...[/color]\n\nAbility Type: [color=purple]Debuff[/color]\nCost: None\nBase: [color=crimson]999[/color]\nScaling: None"
	return str(updated_tooltip)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  _modifiers: ModifierHandler) -> void:
	var damage_effect = DamageEffect.new()
	damage_effect.amount = 999
	damage_effect.sound = sound
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
