extends Ability

const EXPOSED_STATUS = preload("res://Statuses/Ailments/exposed.tres")

var base_damage := 15
var exposed_duration := 2


func update_tooltip(stats: PlayerStats) -> String:
	tooltip_text = "Whack an enemy on the head, dealing " + "[color=firebrick]" + str(int(15 + (stats.strength) * ps_factor)) + "[/color]" + " [color=slate_gray]Physical[/color] damage and inflicting 2 Exposed.\n\nAbility Type: [color=purple]Debuff[/color]\nCost: [color=salmon]10 HP[/color]\nBase: 15\nScaling: (50% STR)"
	return str(tooltip_text)

func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  modifiers: ModifierHandler) -> void:
	var damage_effect = DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
	
	
	var status_effect := StatusEffect.new()
	var exposed := EXPOSED_STATUS.duplicate()
	exposed.duration = exposed_duration
	status_effect.status = exposed
	status_effect.execute(targets, ability, p_s_mod, s_s_mod)
