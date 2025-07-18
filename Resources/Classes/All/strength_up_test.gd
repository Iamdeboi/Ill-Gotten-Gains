extends Ability

const EMPOWERED_STATUS = preload("res://Statuses/AttributeModifiers/AttributeBuff/empowered.tres")

var empowered_stacks := 5

func update_tooltip(_stats: PlayerStats) -> String:
	tooltip_text = "Give yourself %s [color=crimson]Empowered[/color]" % empowered_stacks
	return str(tooltip_text)


func apply_effects(targets: Array[Node], _ability: Ability, _p_s_mod: float, _s_s_mod: float, _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var empowered := EMPOWERED_STATUS.duplicate()
	empowered.stacks = empowered_stacks
	status_effect.status = empowered
	status_effect.execute(targets, _ability, _p_s_mod, _s_s_mod)
	SfxPlayer.play(sound)
