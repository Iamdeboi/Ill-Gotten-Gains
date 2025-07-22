class_name BurnStatus
extends Status

const SINGLE_TARGET_SAMPLE = preload("res://Resources/Classes/Unusable(EffectConditions)/single_target_sample.tres")


func apply_status(target: Node) -> void:
	print("My Burn status targets %s" % [target])
	
	var unmod_damage_effect := UnmodifiedDamageEffect.new()
	unmod_damage_effect.amount = stacks
	unmod_damage_effect.execute([target], SINGLE_TARGET_SAMPLE, 0, 0)
	
	status_applied.emit(self)
