extends Ability

const ENRAGED_STATUS = preload("res://Statuses/MiscBuffs/enraged.tres")

func update_tooltip(stats: PlayerStats) -> String:
	tooltip_text = "[color=crimson]RAGE CONSUMES YOU![/color] Apply 2 [color=crimson]Empowered[/color] to yourself.\n\nAbility Type: [color=lime_green]Buff[/color]\nTargets: Self\nCost:[color=salmon] 20 HP[/color]\nBase: 20\nScaling: None"
	return str(tooltip_text)

func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float) -> void:
	var status_effect := StatusEffect.new()
	var enrage := ENRAGED_STATUS.duplicate()
	status_effect.status = enrage
	status_effect.execute(targets, ability, p_s_mod, s_s_mod)
	SfxPlayer.play(sound)
