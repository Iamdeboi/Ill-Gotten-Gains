extends Ability

var base_armor := 10


func get_updated_tooltip() -> String:
	return tooltip_text

func update_tooltip(stats: PlayerStats, player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var updated_tooltip = "Raise your shield, increasing armor by " + "[color=blue]" + str(int(base_armor + (player_modifiers.get_modified_value(stats.base_constitution, Modifier.Type.CON_MOD) * ps_factor))) + "[/color]" + ". \n\nAbility Type: [color=blue]Defense[/color]\nTargets: Self\nCost: None\nBase: 10\nScaling: (50% CON)"
	return str(updated_tooltip)

func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float,  _modifiers: ModifierHandler) -> void:
	var armor_effect := ArmorEffect.new()
	armor_effect.amount = base_armor
	armor_effect.sound = sound
	armor_effect.execute(targets, ability, p_s_mod, s_s_mod)
