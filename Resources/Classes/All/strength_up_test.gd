extends Ability

const EMPOWERED_STATUS = preload("res://Statuses/AttributeModifiers/AttributeBuff/empowered.tres")

var empowered_stacks := -1


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(_stats: PlayerStats, _player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var updated_tooltip = "Give yourself %s [color=crimson]Empowered[/color]" % empowered_stacks
	return str(updated_tooltip)


func apply_effects(targets: Array[Node], _ability: Ability, _p_s_mod: float, _s_s_mod: float, _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var empowered := EMPOWERED_STATUS.duplicate()
	empowered.stacks = empowered_stacks
	status_effect.status = empowered
	status_effect.execute(targets, _ability, _p_s_mod, _s_s_mod)
	SfxPlayer.play(sound)
