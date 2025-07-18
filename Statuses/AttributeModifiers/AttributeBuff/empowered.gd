class_name EmpoweredStatus
extends Status


func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)


func _on_status_changed(target: Node) -> void:
	# Asert if the target has a modifier_handler node:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	# Assert if the target has a strength_modifier node in their modifier_handler node:
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmg_dealt_modifier, "No strength modifier on %s" % target)
	# Extract a status_modifier variable value of the strength_modifier node's "[status_name_string_id]" to confirm that it exists
	var empowered_modfier_value := dmg_dealt_modifier.get_value("empowered")
	# If this status_modifier has no value, create a new one and assign its ModifierValue Type (either percentage-based or a flat value)
	# Ultlize static function in ModifierValue to create a new modifier away from this script
	if not empowered_modfier_value:
		empowered_modfier_value = ModifierValue.create_new_modifier("empowered", ModifierValue.Type.FLAT)
		
	# Set the value of this modifier equivalent to the number of stacks the status has:
	empowered_modfier_value.flat_value = stacks
	dmg_dealt_modifier.add_new_value(empowered_modfier_value)
