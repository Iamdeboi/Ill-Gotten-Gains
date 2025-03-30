class_name AbilityStateMachine
extends Node

@export var initial_state: AbilityState

var current_state: AbilityState
var states := {}


func init(ability: AbilitySlot) -> void:
	for child: AbilityState in get_children():
		if child:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.ability_slot = ability
		
		if initial_state:
			initial_state.enter()
			current_state = initial_state


func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)


func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)


func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()


func _on_transition_requested(from: AbilityState, to: AbilityState.State) -> void:
	if from != current_state:
		return
	
	var new_state: AbilityState = states[to] #Store reference of new_state to dictionary of states
	if not new_state:
		return
	
	if current_state: #if state exists in the dictionary... exit current state
		current_state.exit()
	
	new_state.enter() #enter new state after exiting previous state
	current_state = new_state
