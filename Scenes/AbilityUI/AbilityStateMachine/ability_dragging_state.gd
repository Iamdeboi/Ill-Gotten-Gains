extends AbilityState

const DRAG_MINIMUM_THRESHOLD := 0.05

var minimum_drag_time_elasped := false


func enter() -> void:
	var ui_layer := get_tree().get_first_node_in_group("UI_Layer")
	if ui_layer:
		ability_slot.reparent(ui_layer)

	ability_slot.color.color = Color.NAVY_BLUE
	ability_slot.state.text = "DRAGGING"
	
	minimum_drag_time_elasped = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func(): minimum_drag_time_elasped = true)


func on_input(event: InputEvent) -> void:
	var single_targeted := ability_slot.ability.is_single_targeted()
	var mouse_motion := event is InputEventMouseMotion
	var cancel := event.is_action_pressed("right_mouse")
	var confirm := event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse") 
	
	if single_targeted and mouse_motion and ability_slot.targets.size() > 0:
		transition_requested.emit(self, AbilityState.State.AIMING)
		return
	
	if mouse_motion:
		ability_slot.global_position = ability_slot.get_global_mouse_position() - ability_slot.pivot_offset
	
	if cancel:
		transition_requested.emit(self, AbilityState.State.BASE)
	elif confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, AbilityState.State.RELEASED)
