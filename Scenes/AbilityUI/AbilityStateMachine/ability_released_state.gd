extends AbilityState

var played: bool

func enter() -> void:
	played = false
	
	if not ability_slot.targets.is_empty(): #Valid target found
		played = true
		ability_slot.play()


func on_input(_event: InputEvent) -> void:
	if played:
		return
	#If no valid target, return to BASE state
	print("Cancelled: Going back to base state")
	transition_requested.emit(self, AbilityState.State.BASE)
