class_name AbilitySlot
extends Control

signal reparent_requested(which_ability: AbilitySlot)


@export var ability: Ability
#@export var player_stats: PlayerStats: set = _set_player_stats

@onready var color: ColorRect = $Color
@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var ability_state_machine: AbilityStateMachine = $AbilityStateMachine as AbilityStateMachine
@onready var targets: Array[Node] = []

var parent: Control
var tween: Tween


func _ready() -> void:
	ability_state_machine.init(self)


func _input(event: InputEvent) -> void:
	ability_state_machine.on_input(event)


func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func _on_gui_input(event: InputEvent) -> void:
	ability_state_machine.on_gui_input(event)


func _on_mouse_entered() -> void:
	ability_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	ability_state_machine.on_mouse_exited()


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
