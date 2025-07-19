class_name AbilityTooltipPopup
extends Control

const ABILITY_MENU_UI_SCENE := preload("res://Scenes/GUI/ability_menu_ui.tscn")

@export var background_color: Color = Color("000000b0")

@onready var background: ColorRect = $Background
@onready var tooltip_ability: CenterContainer = %TooltipAbility
@onready var ability_description: RichTextLabel = %AbilityDescription


func _ready() -> void:
	for ability: AbilityMenuUI in tooltip_ability.get_children():
		ability.queue_free()
		
	background.color = background_color # Reusable background color setting independent per scene
	hide_tooltip()


func show_tooltip(ability: Ability) -> void:
	var new_ability := ABILITY_MENU_UI_SCENE.instantiate() as AbilityMenuUI
	tooltip_ability.add_child(new_ability)
	new_ability.ability = ability
	new_ability.tooltip_requested.connect(hide_tooltip.unbind(1))
	ability_description.text = ability.get_default_tooltip()
	show()


func hide_tooltip() -> void:
	if not visible:
		return
	
	for ability: AbilityMenuUI in tooltip_ability.get_children():
		ability.queue_free()
	
	hide()
