class_name AbilityState
extends Node

enum State {BASE, CLICKED, DRAGGING, AIMING, RELEASED}

signal transition_requested(from: AbilityState, to: State)

@export var state: State

var ability_slot: AbilitySlot


func enter() -> void:
	pass


func exit() -> void:
	pass


func on_input(_event: InputEvent) -> void:
	pass


func on_gui_input(_event: InputEvent) -> void:
	pass


func on_mouse_entered() -> void:
	pass


func on_mouse_exited() -> void:
	pass
