class_name AbilityMenuView
extends Control
# This is the "Spellbook" of the game, also can be used in other menus for similar purposes of displaying abilities with tooltips.
const ABILITY_MENU_UI_SCENE := preload("res://Scenes/GUI/ability_menu_ui.tscn")

@export var ability_list: AbilityList

@onready var title: Label = %Title
@onready var known_abilities: GridContainer = %KnownAbilities
@onready var ability_tooltip_popup: AbilityTooltipPopup = %AbilityTooltipPopup
@onready var back_button: Button = %BackButton


func _ready() -> void:
	back_button.pressed.connect(hide)
	
	for ability: Node in known_abilities.get_children():
		ability.queue_free() #Get rid of placeholder abilities before placing the ones we want
	
	ability_tooltip_popup.hide_tooltip()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if ability_tooltip_popup.visible:
			ability_tooltip_popup.hide_tooltip()
		else:
			hide()


func show_current_view(new_title: String) -> void:
	for ability: Node in known_abilities.get_children():
		ability.queue_free()
	
	ability_tooltip_popup.hide_tooltip()
	title.text = new_title
	_update_view.call_deferred()


func _update_view() -> void:
	if not ability_list:
		return
	
	var all_abilities := ability_list.abilities.duplicate()
	
	for ability: Ability in all_abilities:
		var new_ability := ABILITY_MENU_UI_SCENE.instantiate() as AbilityMenuUI
		known_abilities.add_child(new_ability)
		new_ability.ability = ability
		new_ability.tooltip_requested.connect(ability_tooltip_popup.show_tooltip)
		
	show()
