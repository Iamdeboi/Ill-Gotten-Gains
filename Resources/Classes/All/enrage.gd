extends Ability

const ENRAGED_STATUS = preload("res://Statuses/MiscBuffs/enraged.tres")


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(_stats: PlayerStats, _player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var updated_tooltip = "[color=crimson]RAGE CONSUMES YOU![/color] Apply 2 [color=crimson]Empowered[/color] to yourself. This effect remains for the rest of combat.\n\nAbility Type: [color=lime_green]Buff[/color]\nTargets: Self\nCost:[color=salmon] 20 HP[/color]\nBase: 20\nScaling: None"
	return str(updated_tooltip)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var enrage := ENRAGED_STATUS.duplicate()
	status_effect.status = enrage
	status_effect.execute(targets, ability, p_s_mod, s_s_mod)
	SfxPlayer.play(sound)
