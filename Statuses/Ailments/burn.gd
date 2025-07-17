class_name BurnStatus
extends Status

const MODIFIER := 0.5
const SINGLE_TARGET_SAMPLE = preload("res://Resources/Classes/Unusable(EffectConditions)/single_target_sample.tres")

func apply_status(target: Node) -> void:
	print("My status targets %s" % [target])
	
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 5
	damage_effect.execute([target], SINGLE_TARGET_SAMPLE, 0, 0)
	
	status_applied.emit(self)
