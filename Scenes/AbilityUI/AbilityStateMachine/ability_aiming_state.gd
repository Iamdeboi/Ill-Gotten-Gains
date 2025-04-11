extends AbilityState

const MOUSE_Y_SNAPBACK_THRESHOLD := 300


func enter() -> void:
	ability_slot.targets.clear()
	var offset := Vector2(ability_slot.parent.size.x / 2, -ability_slot.size.y / 2)
	offset.x -= ability_slot.size.x / 2
	ability_slot.animate_to_position(ability_slot.parent.global_position + offset, 0.2)
	ability_slot.drop_point_detector.monitoring = false
	EventBus.ability_targeting_started.emit(ability_slot)
	SfxPlayer.play(ability_slot.ability.aiming_audio)


func exit() -> void:
	EventBus.ability_targeting_ended.emit(ability_slot)
	SfxPlayer.stop()

func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var mouse_at_bottom := ability_slot.get_global_mouse_position().y > MOUSE_Y_SNAPBACK_THRESHOLD
	
	if (mouse_motion and mouse_at_bottom) or event.is_action_pressed("right_mouse"):
		transition_requested.emit(self, AbilityState.State.BASE)
	elif event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse"):
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, AbilityState.State.RELEASED)
