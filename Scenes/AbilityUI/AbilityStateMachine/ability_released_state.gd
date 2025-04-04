extends AbilityState

var played: bool

func enter() -> void:
	played = false
	
	if not ability_slot.targets.is_empty(): #Valid target found
		EventBus.tooltip_hide_requested.emit()
		played = true
		ability_slot.play()

func on_input(_event: InputEvent) -> void:
	if played:
		played = false
	
	transition_requested.emit(self, AbilityState.State.BASE)
