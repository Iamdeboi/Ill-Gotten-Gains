class_name ExposedStatus
extends Status

const MODIFIER := 0.5
const SINGLE_TARGET_SAMPLE = preload("res://Resources/Classes/Unusable(EffectConditions)/single_target_sample.tres")

func apply_status(target: Node) -> void:
	print("%s should take %s%% more damage!" % [target, MODIFIER * 100])
	
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 12
	damage_effect.execute([target], SINGLE_TARGET_SAMPLE, 0, 0)
	
	status_applied.emit(self)
