extends EnemyAction

@export var damage := 1
@export var ability_ref: Ability


var p_s_mod: float 
var s_s_mod : float

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := enemy.global_position + Vector2.UP * 32
	var damage_effect := DamageEffect.new()
	var target_array : Array[Node] = [target]
	
	damage_effect.amount = damage
	p_s_mod = calculate_primary_scaling_mod(ability_ref)
	s_s_mod = calculate_secondary_scaling_mod(ability_ref)
	
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_interval(0.25)
	tween.tween_property(enemy, "global_position", start, 0.4)
	tween.tween_callback(damage_effect.execute.bind(target_array, ability_ref, p_s_mod, s_s_mod))
	
	tween.finished.connect(
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
			p_s_mod = enemy.stats.constituion * ability_ref.ps_factor
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
			s_s_mod = enemy.stats.constituion * ability_ref.ss_factor
	return s_s_mod
