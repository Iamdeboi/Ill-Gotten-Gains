extends AbilityState


func enter() -> void:
	ability_slot.drop_point_detector.monitoring = true


func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, AbilityState.State.DRAGGING)
