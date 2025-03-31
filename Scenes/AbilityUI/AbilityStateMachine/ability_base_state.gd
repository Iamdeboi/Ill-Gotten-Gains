extends AbilityState


func enter() -> void:
	if not ability_slot.ready:
		await ability_slot.ready
	
	if ability_slot.tween and ability_slot.tween.is_running():
		ability_slot.tween.kill()
	
	ability_slot.background.set("theme_override_styles/panel", ability_slot.BASE_STYLEBOX)
	ability_slot.reparent_requested.emit(ability_slot)
	ability_slot.pivot_offset = Vector2.ZERO
	EventBus.tooltip_hide_requested.emit()


func on_gui_input(event: InputEvent) -> void:
	if not ability_slot.playable or ability_slot.disabled:
		return
	
	if event.is_action_pressed("left_mouse"):
		ability_slot.pivot_offset = ability_slot.get_global_mouse_position() - ability_slot.global_position
		transition_requested.emit(self, AbilityState.State.CLICKED)


func on_mouse_entered() -> void:
	if not ability_slot.playable or ability_slot.disabled:
		return
	
	ability_slot.background.set("theme_override_styles/panel", ability_slot.HOVER_STYLEBOX)
	EventBus.ability_tooltip_requested.emit(ability_slot.ability.icon, ability_slot.ability.title, ability_slot.ability.tooltip_text)

func on_mouse_exited() -> void:
	if not ability_slot.playable or ability_slot.disabled:
		return
	
	ability_slot.background.set("theme_override_styles/panel", ability_slot.BASE_STYLEBOX)
	EventBus.tooltip_hide_requested.emit()
