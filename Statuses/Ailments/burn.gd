class_name BurnStatus
extends Status


func get_tooltip() -> String:
	return tooltip % [stacks, duration]


func apply_status(target: Node) -> void:
	# Attaching Fire Element to incoming Damage
	var sample_fire_ability = Ability.new()
	sample_fire_ability.element_type = sample_fire_ability.ElementType.FIRE
	# Unmodified Damage Effect (Does not benefit from DMG_TAKEN modifier of target)
	var unmod_damage_effect := UnmodifiedDamageEffect.new()
	unmod_damage_effect.amount = stacks
	unmod_damage_effect.execute([target], sample_fire_ability, 0, 0)
	
	status_applied.emit(self)
