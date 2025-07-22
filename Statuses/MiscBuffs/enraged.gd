class_name EnragedStatus
extends Status

const EMPOWERED_STATUS = preload("res://Statuses/AttributeModifiers/empowered.tres")
const SINGLE_TARGET_SAMPLE = preload("res://Resources/Classes/Unusable(EffectConditions)/single_target_sample.tres")

var stacks_per_turn := 2

func apply_status(target: Node) -> void:
	var status_effect := StatusEffect.new()
	var empowered := EMPOWERED_STATUS.duplicate()
	empowered.stacks = stacks_per_turn
	status_effect.status = empowered
	status_effect.execute([target], SINGLE_TARGET_SAMPLE, 0, 0) # ability, p_s_mod, and s_s_mod are irrelevant for execution
	
	status_applied.emit(self)
