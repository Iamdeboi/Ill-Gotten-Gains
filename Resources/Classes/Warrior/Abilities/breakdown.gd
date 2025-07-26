extends Ability

const EXPOSED_STATUS = preload("res://Statuses/Ailments/exposed.tres")

var base_damage := 15
var exposed_duration := 2


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(stats: PlayerStats, player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var pre_mod_dmg = base_damage + (player_modifiers.get_modified_value(stats.base_strength, Modifier.Type.STR_MOD)) * (ps_factor)
	var final_dmg = player_modifiers.get_modified_value(pre_mod_dmg, Modifier.Type.DMG_DEALT)
	if enemy_modifiers:
		final_dmg = enemy_modifiers.get_modified_value(final_dmg, Modifier.Type.DMG_TAKEN)
		
	var updated_tooltip = "Bash an enemy on the head, dealing " + "[color=firebrick]" + str(final_dmg) + "[/color]" + " [color=slate_gray]Physical[/color] damage and inflicting 2 Exposed.\n\nAbility Type: [color=purple]Debuff[/color]\nTargets: Single Enemy\nCost: [color=salmon]10 HP[/color]\nBase: 15\nScaling: (50% STR)"
	return str(updated_tooltip)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  modifiers: ModifierHandler) -> void:
	# Damage Component:
	var damage_effect = DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
	# Status Effect Component:
	var status_effect := StatusEffect.new()
	var exposed := EXPOSED_STATUS.duplicate()
	exposed.duration = exposed_duration
	status_effect.status = exposed
	status_effect.execute(targets, ability, p_s_mod, s_s_mod)
