extends AbilityState

var played: bool

func enter() -> void:
	ability_slot.color.color = Color.DARK_VIOLET
	ability_slot.state.text = "RELEASED"
	
	played = false

	if not ability_slot.targets.is_empty(): #Valid target found
		played = true
		print("play ability for target(s):",  ability_slot.targets)



func on_input(_event: InputEvent) -> void:
	if played:
		return
	#If no valid target, return to BASE state
	print("Cancelled: Going back to base state")
	transition_requested.emit(self, AbilityState.State.BASE)
