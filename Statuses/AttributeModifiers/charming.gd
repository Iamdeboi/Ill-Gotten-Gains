class_name CharmingStatus
extends Status


func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)


func _on_status_changed(target: Node) -> void:
	# Asert if the target has a modifier_handler node:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	# Assert if the target has a charisma_modifier node in their modifier_handler node:
	var charisma_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.CHA_MOD)
	assert(charisma_modifier, "No strength modifier on %s" % target)
	# Extract a status_modifier variable value of the appropriate modifier_handler's modifier node: "[status_name_string_id]" to confirm that it exists
	var charming_modfier_value := charisma_modifier.get_value("charming")
	# If this status_modifier has no value, create a new one and assign its ModifierValue Type (either percentage-based or a flat value)
	# Ultlize static function in ModifierValue to create a new modifier away from this script
	if not charming_modfier_value:
		charming_modfier_value = ModifierValue.create_new_modifier("charming", ModifierValue.Type.FLAT)
		
	# Set the value of this modifier equivalent to the number of stacks the status has:
	charming_modfier_value.flat_value = stacks
	charisma_modifier.add_new_value(charming_modfier_value)
	target.update_stats()
