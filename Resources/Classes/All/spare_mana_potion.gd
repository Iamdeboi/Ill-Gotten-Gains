extends Ability


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(stats: PlayerStats, _player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var updated_tooltip = "Hey, a spare potion! Drinking this will restore your mana by [color=light_blue]20[/color].\n\nAbility Type: [color=lime_green]Buff[/color]\nCost: None\nBase: 20\nScaling: None"
	return str(updated_tooltip)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  _modifiers: ModifierHandler) -> void:
	var mana_restore_effect := ManaRestoreEffect.new()
	mana_restore_effect.amount = 20
	mana_restore_effect.sound = sound
	mana_restore_effect.execute(targets, ability, p_s_mod, s_s_mod)
