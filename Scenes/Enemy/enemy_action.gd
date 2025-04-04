class_name EnemyAction
extends Node

enum Type {CONDITIONAL, CHANCE_BASED}

@export var type: Type
@export_range(0.0, 10.0) var chance_weight := 0.0

@onready var accumulated_weight := 0.0

var enemy: Enemy
var target: Node


func is_performable() -> bool: #Must be overwritten through checks on attacks or abilities cast, used with Conditionals
	return false


func perform_action() -> void: #All logic behind enemy actions is done here; tweens, animations, etc.
	pass
