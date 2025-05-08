class_name AbilityVisuals
extends Control

@export var ability: Ability : set = set_ability

const ATTACK_SLOT_BG := preload("res://Assets/art/AttackAbilityIcon.png")
const DEFENSE_SLOT_BG := preload("res://Assets/art/DefenseAbilityIcon.png")
const BUFF_SLOT_BG := preload("res://Assets/art/BuffAbilityIcon.png")
const DEBUFF_SLOT_BG := preload("res://Assets/art/DebuffAbilityIcon.png")

@onready var background: TextureRect = $Background
@onready var icon: TextureRect = $Icon
@onready var cost_count: Label = $CostCount


func set_ability(value: Ability) -> void:
	if not is_node_ready():
		await ready

	ability = value

	if ability.cost == 0: # Dont show a cost number if it already equals nothing
		cost_count.hide()
	cost_count.text = str(ability.cost)

	match ability.cost_type: # Color the cost number to quickly show if it costs MANA, HEALTH, or GOLD
		ability.CostType.MANA:
			cost_count.add_theme_color_override("font_color", Color.DARK_TURQUOISE)
		ability.CostType.HEALTH:
			cost_count.add_theme_color_override("font_color", Color.SALMON)
		ability.CostType.GOLD:
			cost_count.add_theme_color_override("font_color", Color.GOLD)

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
