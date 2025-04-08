extends EnemyAction

@export var armor := 1
@export var ability_ref: Ability

var p_s_mod: float
var s_s_mod: float


func perform_action() -> void:
	if not enemy or not target:
		return
	
	var armor_effect := ArmorEffect.new()
	armor_effect.amount = armor
	calculate_primary_scaling_mod(ability_ref)
	calculate_secondary_scaling_mod(ability_ref)
	armor_effect.execute([enemy], ability_ref, p_s_mod, s_s_mod)
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			EventBus.enemy_action_completed.emit(enemy)
	)

func calculate_primary_scaling_mod(ability_ref: Ability) -> float:
	match ability_ref.primary_scaling:
		ability_ref.Scaling.NONE:
			pass
		ability_ref.Scaling.STRENGTH:
			p_s_mod = enemy.stats.strength * ability_ref.ps_factor
		ability_ref.Scaling.DEXTERITY:
			p_s_mod = enemy.stats.dexterity * ability_ref.ps_factor
		ability_ref.Scaling.INTELLECT:
			p_s_mod = enemy.stats.intellect * ability_ref.ps_factor
		ability_ref.Scaling.CHARISMA:
			p_s_mod = enemy.stats.charisma * ability_ref.ps_factor
		ability_ref.Scaling.WISDOM:
			p_s_mod = enemy.stats.wisdom * ability_ref.ps_factor
		ability_ref.Scaling.CONSTITUTION:
			p_s_mod = enemy.stats.constitution * ability_ref.ps_factor
	return p_s_mod


func calculate_secondary_scaling_mod(ability_ref: Ability) -> float:
	match ability_ref.secondary_scaling_mod:
		ability_ref.Scaling.NONE:
			pass
		ability_ref.Scaling.STRENGTH:
			s_s_mod = enemy.stats.strength * ability_ref.ss_factor
		ability_ref.Scaling.DEXTERITY:
			s_s_mod = enemy.stats.dexterity * ability_ref.ss_factor
		ability_ref.Scaling.INTELLECT:
			s_s_mod = enemy.stats.intellect * ability_ref.ss_factor
		ability_ref.Scaling.CHARISMA:
			s_s_mod = enemy.stats.charisma * ability_ref.ss_factor
		ability_ref.Scaling.WISDOM:
			s_s_mod = enemy.stats.wisdom * ability_ref.ss_factor
		ability_ref.Scaling.CONSTITUTION:
			s_s_mod = enemy.stats.constitution * ability_ref.ss_factor
	return s_s_mod


func calculate_action() -> int: # For Intent "number" String updates
	if not enemy or not target:
		return 0
	
	var calc_p_s_mod = calculate_primary_scaling_mod(ability_ref)
	var calc_s_s_mod = calculate_secondary_scaling_mod(ability_ref)
	var calculation = armor + calc_p_s_mod + calc_s_s_mod
	return int(calculation)
