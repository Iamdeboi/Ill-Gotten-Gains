class_name AbilitySlot
extends Control

signal reparent_requested(which_ability: AbilitySlot)

const BASE_STYLEBOX := preload("res://Scenes/AbilityUI/ability_slot_base.stylebox")
const DRAG_STYLEBOX := preload("res://Scenes/AbilityUI/ability_slot_dragging.stylebox")
const HOVER_STYLEBOX := preload("res://Scenes/AbilityUI/ability_slot_hover.stylebox")

@export var ability: Ability: set = _set_ability
@export var player_stats: PlayerStats : set = _set_player_stats

@onready var background: Panel = $Background
@onready var cost: Label = $CostCount
@onready var icon: TextureRect = $Icon
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var ability_state_machine: AbilityStateMachine = $AbilityStateMachine as AbilityStateMachine
@onready var targets: Array[Node] = []
@onready var original_index := self.get_index()

var tooltip_string: String
var parent: Control
var tween: Tween
var playable := true: set = _set_playable # Checks if enough resource is available to play ability
var disabled := false # Locked from interacting via clicking, dragging, moving

func _ready() -> void:
	EventBus.ability_targeting_started.connect(_on_ability_drag_or_targeting_started)
	EventBus.ability_drag_started.connect(_on_ability_drag_or_targeting_started)
	EventBus.ability_targeting_ended.connect(_on_ability_drag_or_targeting_ended)
	EventBus.ability_drag_ended.connect(_on_ability_drag_or_targeting_ended)
	ability_state_machine.init(self)


func _input(event: InputEvent) -> void:
	ability_state_machine.on_input(event)


func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func play() -> void:
	if not ability:
		return
	
	ability.play(targets, player_stats, ability)

func _on_gui_input(event: InputEvent) -> void:
	ability_state_machine.on_gui_input(event)


func _on_mouse_entered() -> void:
	ability_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	ability_state_machine.on_mouse_exited()

func _set_ability(value: Ability) -> void:
	if not is_node_ready():
		await ready
	
	ability = value
	
	if ability.cost == 0: # Dont show a cost number if it already equals nothing
		cost.hide()
	cost.text = str(ability.cost)
	
	match ability.cost_type: # Color the cost number to quickly show if it costs MANA, HEALTH, or GOLD
		ability.CostType.MANA:
			cost.add_theme_color_override("font_color", Color.DARK_TURQUOISE)
		ability.CostType.HEALTH:
			cost.add_theme_color_override("font_color", Color.SALMON)
		ability.CostType.GOLD:
			cost.add_theme_color_override("font_color", Color.GOLD)
	icon.texture = ability.icon



func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1, 1, 1, 0.5) #Adds transparancy to the ability slot
	else: # Reset font_color based on their disabled status, and cost_type color
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1, 1, 1, 1) #Default look
		match ability.cost_type: # Color the cost number to quickly show if it costs MANA, HEALTH, or GOLD
			ability.CostType.MANA:
				cost.add_theme_color_override("font_color", Color.DARK_TURQUOISE)
			ability.CostType.HEALTH:
				cost.add_theme_color_override("font_color", Color.SALMON)
			ability.CostType.GOLD:
				cost.add_theme_color_override("font_color", Color.GOLD)


func _set_player_stats(value: PlayerStats) -> void:
	player_stats = value
	player_stats.stats_changed.connect(_on_player_stats_changed)


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)


func _on_ability_drag_or_targeting_started(used_ability: AbilitySlot) -> void:
	if used_ability == self:
		return
	
	disabled = true


func _on_ability_drag_or_targeting_ended(_used_ability: AbilitySlot) -> void:
	disabled = false
	self.playable = player_stats.can_play_ability(ability)


func _on_player_stats_changed() -> void:
	self.playable = player_stats.can_play_ability(ability)
