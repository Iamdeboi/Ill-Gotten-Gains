class_name EnlightenedStatus
extends Status


func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)


func _on_status_changed(target: Node) -> void:
	# Asert if the target has a modifier_handler node:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	# Assert if the target has a intellect_modifier node in their modifier_handler node:
	var intellect_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.INT_MOD)
	assert(intellect_modifier, "No intellect modifier on %s" % target)
	# Extract a status_modifier variable value of the appropriate modifier_handler's modifier node: "[status_name_string_id]" to confirm that it exists
	var enlightened_modifier_value := intellect_modifier.get_value("enlightened")
	# If this status_modifier has no value, create a new one and assign its ModifierValue Type (either percentage-based or a flat value)
	# Ultlize static function in ModifierValue to create a new modifier away from this script
	if not enlightened_modifier_value:
		enlightened_modifier_value = ModifierValue.create_new_modifier("enlightened", ModifierValue.Type.FLAT)
		
	# Set the value of this modifier equivalent to the number of stacks the status has:
	enlightened_modifier_value.flat_value = stacks
	intellect_modifier.add_new_value(enlightened_modifier_value)
	target.update_stats()
