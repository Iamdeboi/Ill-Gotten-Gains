class_name AbilityMenuUI
extends CenterContainer

signal tooltip_requested(ability: Ability)

const ATTACK_SLOT_BG := preload("res://Assets/art/AttackAbilityIcon.png")
const DEFENSE_SLOT_BG := preload("res://Assets/art/DefenseAbilityIcon.png")
const BUFF_SLOT_BG := preload("res://Assets/art/BuffAbilityIcon.png")
const DEBUFF_SLOT_BG := preload("res://Assets/art/DebuffAbilityIcon.png")

@export var ability: Ability : set = _set_ability

@onready var background: TextureRect = $Visuals/Background
@onready var icon: TextureRect = $Visuals/Icon
@onready var cost: Label = $Visuals/CostCount


func _on_visuals_mouse_entered() -> void:
	pass # Replace with function body.
	#TODO: make a stylebox compatible with the premade slots


func _on_visuals_mouse_exited() -> void:
	pass # Replace with function body.
	#TODO: make a stylebox compatible with the premade slots


func _on_visuals_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		tooltip_requested.emit(ability)


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
	
	match ability.ability_type: # Set the background of the ability for simple readability for its function
		ability.AbilityType.ATTACK:
			background.texture = ATTACK_SLOT_BG
		ability.AbilityType.DEFENSE:
			background.texture = DEFENSE_SLOT_BG
		ability.AbilityType.BUFF:
			background.texture = BUFF_SLOT_BG
		ability.AbilityType.DEBUFF:
			background.texture = DEBUFF_SLOT_BG

	icon.texture = ability.icon
