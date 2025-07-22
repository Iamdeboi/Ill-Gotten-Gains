# meta-name: Ability Logic
# meta-description: What hapenns when an ability is played.
extends Ability
# Remember to consider the ModifierHandler components to the ability if needed, remove the "_" from the parameters to ultlize them!

var base_something := 1


func get_default_tooltip() -> String:
	return tooltip_text


func update_tooltip(stats: PlayerStats, _player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	tooltip_text = "This is a sample ability, dealing " + "[color=firebrick]" + str(int(15 + (stats.strength) * ps_factor)) + "[/color]" + " [color=slate_gray]Physical[/color] damage.\n\nAbility Type: [color=firebrick]Attack[/color]\nTargets: Single Enemy\nCost: [color=salmon]10 HP[/color]\nBase: 15\nScaling: (50% STR)"
	return str(tooltip_text)


func apply_effects(targets: Array[Node], _ability: Ability, _p_s_mod: float, _s_s_mod: float, _modifiers: ModifierHandler) -> void:
	print("The ability has been played")
	print("Targets: %s" % targets)
