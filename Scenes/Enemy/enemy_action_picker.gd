class_name EnemyActionPicker
extends Node
# The "brain" of the AI, requires a ref for the enemy using the actions, and its target; set the total weight of all actions to configure chances

@export var enemy: Enemy: set = _set_enemy
@export var target: Node: set = _set_target

@onready var total_weight := 0.0


func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")
	setup_chances()


func get_action() -> EnemyAction:
	var action := get_first_conditional_action()
	if action:
		return action
	
	return get_chance_based_action()


func get_first_conditional_action() -> EnemyAction: # Always has priority over Chance-Based-Actions
	var action: EnemyAction
	
	for child in get_children():
		action = child as EnemyAction
		if not action or action.type != EnemyAction.Type.CONDITIONAL:
			continue
		
		if action.is_performable():
			return action
	
	return null # After all iterations, not a single action was conditional


func get_chance_based_action() -> EnemyAction:
	var action: EnemyAction
	var roll := randf_range(0.0, total_weight)
	
	for child in get_children():
		action = child as EnemyAction
		if not action or action.type != EnemyAction.Type.CHANCE_BASED:
			continue
		
		if action.accumulated_weight > roll:
			return action
	
	return null


func setup_chances() -> void:
	var action: EnemyAction
	
	for child in get_children():
		action = child as EnemyAction
		if not action or action.type != EnemyAction.Type.CHANCE_BASED:
			continue
		
		total_weight += action.chance_weight # Add all assigned weight values from each action
		action.accumulated_weight = total_weight # Accumulated weight is calculated after all actions and their individual weights are collected


func _set_enemy(value: Enemy) -> void:
	enemy = value
	
	for action in get_children():
		action.enemy = enemy


func _set_target(value: Node) -> void: 
	target = value
	
	for action in get_children():
		action.target = target
