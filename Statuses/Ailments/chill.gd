class_name ChillStatus
extends Status


func get_tooltip() -> String:
	return tooltip % [stacks, duration]


func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)


func _on_status_changed(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmg_dealt_modifier, "No dmg dealt modifier on %s" % target)
	
	var chill_modifier_value := dmg_dealt_modifier.get_value("chill")
	
	if not chill_modifier_value:
		chill_modifier_value = ModifierValue.create_new_modifier("chill", ModifierValue.Type.FLAT)
		
	chill_modifier_value.flat_value = -stacks
	dmg_dealt_modifier.add_new_value(chill_modifier_value)
