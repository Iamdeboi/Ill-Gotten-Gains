class_name ExposedStatus
extends Status

const MODIFIER := 0.5
const SINGLE_TARGET_SAMPLE = preload("res://Resources/Classes/Unusable(EffectConditions)/single_target_sample.tres")


func initialize_status(target: Node) -> void:
	# Asert if the target has a modifier_handler node:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	# Assert if the target has a strength_modifier node in their modifier_handler node:
	var dmg_taken_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_TAKEN)
	assert(dmg_taken_modifier, "No dmg taken modifier on %s" % target)
	# Extract a status_modifier variable value of the strength_modifier node's "[status_name_string_id]" to confirm that it exists
	var exposed_modfier_value := dmg_taken_modifier.get_value("exposed")
	# If this status_modifier has no value, create a new one and assign its ModifierValue Type (either percentage-based or a flat value)
	# Ultlize static function in ModifierValue to create a new modifier away from this script
	if not exposed_modfier_value:
		exposed_modfier_value = ModifierValue.create_new_modifier("exposed", ModifierValue.Type.PERCENT_BASED)
		exposed_modfier_value.percent_value = MODIFIER
		dmg_taken_modifier.add_new_value(exposed_modfier_value)
	# Connect signal to the newly created modifier node
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(dmg_taken_modifier))


func _on_status_changed(dmg_taken_modifier: Modifier) -> void:
	if duration <= 0 and dmg_taken_modifier:
		dmg_taken_modifier.remove_value("exposed") # Remove modifier when duration expires
