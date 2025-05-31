class_name AbilityRewards
extends ColorRect

signal ability_reward_selected(ability: Ability)

const ABILITY_MENU_UI = preload("res://Scenes/GUI/ability_menu_ui.tscn")

@export var rewards : Array[Ability] : set = set_rewards

@onready var abilities: HBoxContainer = %Abilities
@onready var skip_ability_reward: Button = %SkipAbilityReward
@onready var ability_tooltip_popup: AbilityTooltipPopup = $AbilityTooltipPopup
@onready var take_button: Button = %TakeButton

var selected_ability

func _ready() -> void:
	_clear_rewards()
	
	take_button.pressed.connect(
		func():
			ability_reward_selected.emit(selected_ability)
			print("drafted %s" % selected_ability.id)
			queue_free()
	)
	
	skip_ability_reward.pressed.connect(
		func():
			ability_reward_selected.emit(null)
			print("Skipped Ability Reward")
			queue_free()
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		ability_tooltip_popup.hide_tooltip()


func _clear_rewards() -> void:
	for ability: Node in abilities.get_children():
		ability.queue_free()
		
	ability_tooltip_popup.hide_tooltip()
	
	selected_ability = null


func _show_tooltip(ability: Ability) -> void:
	selected_ability = ability
	ability_tooltip_popup.show_tooltip(ability)


func set_rewards(new_abilities: Array[Ability]) -> void:
	rewards = new_abilities
	
	if not is_node_ready():
		await ready
	
	_clear_rewards()
	for ability: Ability in rewards:
		var new_ability := ABILITY_MENU_UI.instantiate() as AbilityMenuUI
		abilities.add_child(new_ability)
		new_ability.ability = ability
		new_ability.tooltip_requested.connect(_show_tooltip)
