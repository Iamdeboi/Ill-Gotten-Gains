class_name EmpoweredStatus
extends Status


func get_tooltip() -> String:
	return tooltip % stacks


func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)


func _on_status_changed(target: Node) -> void:
	# Asert if the target has a modifier_handler node:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	# Assert if the target has a strength_modifier node in their modifier_handler node:
	var strength_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.STR_MOD)
	assert(strength_modifier, "No strength modifier on %s" % target)
	# Extract a status_modifier variable value of the appropriate modifier_handler's modifier node: "[status_name_string_id]" to confirm that it exists
	var empowered_modfier_value := strength_modifier.get_value("empowered")
	# If this status_modifier has no value, create a new one and assign its ModifierValue Type (either percentage-based or a flat value)
	# Ultlize static function in ModifierValue to create a new modifier away from this script
	if not empowered_modfier_value:
		empowered_modfier_value = ModifierValue.create_new_modifier("empowered", ModifierValue.Type.FLAT)
	# Set the value of this modifier equivalent to the number of stacks the status has:
	empowered_modfier_value.flat_value = stacks
	strength_modifier.add_new_value(empowered_modfier_value)
	target.update_stats()
