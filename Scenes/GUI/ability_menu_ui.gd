class_name AbilityMenuUI
extends CenterContainer

signal tooltip_requested(ability: Ability)

@export var ability: Ability : set = _set_ability

@onready var ability_visuals: AbilityVisuals = $AbilityVisuals


func _set_ability(value: Ability) -> void:
	if not is_node_ready():
		await ready
	
	ability = value
	ability_visuals.ability = ability


func _on_ability_visuals_mouse_entered() -> void:
	pass # Replace with function body.


func _on_ability_visuals_mouse_exited() -> void:
	pass # Replace with function body.


func _on_ability_visuals_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		tooltip_requested.emit(ability)
