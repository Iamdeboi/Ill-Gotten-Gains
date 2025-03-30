extends AbilityState


func enter() -> void:
	if not ability_slot.ready:
		await ability_slot.ready
	
	if ability_slot.tween and ability_slot.tween.is_running():
		ability_slot.tween.kill()
	
	ability_slot.reparent_requested.emit(ability_slot)
	ability_slot.color.color = Color.WEB_GREEN
	ability_slot.state.text = "BASE"
	ability_slot.pivot_offset = Vector2.ZERO


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		ability_slot.pivot_offset = ability_slot.get_global_mouse_position() - ability_slot.global_position
		transition_requested.emit(self, AbilityState.State.CLICKED)
