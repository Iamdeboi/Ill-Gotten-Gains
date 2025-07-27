extends Ability
# Remember to consider the ModifierHandler components to the ability if needed, remove the "_" from the parameters to ultlize them!
const CHILL_STATUS := preload("res://Statuses/Ailments/chill.tres")

var base_damage : int = 2
var chill_stack_value : int = 1
var chill_duration_value : int = 2


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(stats: PlayerStats, player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var pre_mod_dmg = base_damage + (player_modifiers.get_modified_value(stats.base_intellect, Modifier.Type.INT_MOD)) * (ps_factor)
	pre_mod_dmg += (player_modifiers.get_modified_value(stats.base_wisdom, Modifier.Type.WIS_MOD) * (ss_factor))
	var final_dmg = player_modifiers.get_modified_value(pre_mod_dmg, Modifier.Type.DMG_DEALT)
	if enemy_modifiers:
		final_dmg = enemy_modifiers.get_modified_value(final_dmg, Modifier.Type.DMG_TAKEN)
	var updated_tooltip = "This is a chill ability, dealing " + "[color=firebrick]" + str(final_dmg) + "[/color]" + " [color=pale_turquoise]Frost[/color] damage.\n\nAbility Type: [color=firebrick]Attack[/color]\nTargets: Single Enemy\nCost: [color=cyan]5 MP[/color]\nBase: 15\nScaling: (50% STR)"
	return str(updated_tooltip)


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float, modifiers: ModifierHandler) -> void:
	# Damage Component:
	var damage_effect = DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets, ability, p_s_mod, s_s_mod)
	# Status Effect Component:
	var status_effect := StatusEffect.new()
	var chill := CHILL_STATUS.duplicate()
	chill.duration = chill_duration_value
	chill.stacks = chill_stack_value
	status_effect.status = chill
	status_effect.execute(targets, ability, p_s_mod, s_s_mod)
