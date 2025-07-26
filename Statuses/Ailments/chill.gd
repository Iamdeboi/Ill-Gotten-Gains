class_name ChillStatus
extends Status


func get_tooltip() -> String:
	return tooltip % [stacks, duration]


func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)


func _on_status_changed(target: Node) -> void:
	# Asert if the target has a modifier_handler node:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	# Assert if the target has a dmg_dealt_modifier node in their modifier_handler node:
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmg_dealt_modifier, "No dmg dealt modifier on %s" % target)
	# Extract a status_modifier variable value of the appropriate modifier_handler's modifier node: "[status_name_string_id]" to confirm that it exists
	var chill_modfier_value := dmg_dealt_modifier.get_value("chill")
	# If this status_modifier has no value, create a new one and assign its ModifierValue Type (either percentage-based or a flat value)
	# Ultlize static function in ModifierValue to create a new modifier away from this script
	if not chill_modfier_value:
		chill_modfier_value = ModifierValue.create_new_modifier("chill", ModifierValue.Type.FLAT)
	# Set the value of this modifier equivalent to the number of stacks the status has:
	chill_modfier_value.flat_value = -stacks
	dmg_dealt_modifier.add_new_value(chill_modfier_value)
	
	if duration <= 0 and dmg_dealt_modifier:
		dmg_dealt_modifier.remove_value("chill") # Remove modifier when duration expires
	
	target.update_stats()
	
	if target == Enemy:
		target.update_intent()
