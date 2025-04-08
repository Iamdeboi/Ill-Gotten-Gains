class_name AbilityContainer
extends GridContainer
# The GridContainer node for ability_slots (the ability ui element) in each battle scene and the spellbook
# This node makes new ability_slot nodes from a given [AbilityList] and their individual [Ability]s


@export var player_stats: PlayerStats

@onready var ability_slot := preload("res://Scenes/AbilityUI/ability_slot.tscn")

var abilities_played_this_turn := 0


func _ready() -> void:
	EventBus.ability_used.connect(_on_ability_used)


func add_ability(ability: Ability) -> void:
	var new_ability_slot := ability_slot.instantiate()
	add_child(new_ability_slot)
	new_ability_slot.reparent_requested.connect(_on_ability_ui_reparent_requested)
	new_ability_slot.ability = ability
	new_ability_slot.ability.tooltip_text = new_ability_slot.ability.update_tooltip(player_stats)
	new_ability_slot.parent = self
	new_ability_slot.player_stats = player_stats #Dependency from own


func disable_hotbar() -> void:
	for ability_slot in get_children():
		ability_slot.disabled = true


func enable_hotbar() -> void:
	for ability_slot in get_children():
		ability_slot.disabled = false


func _on_ability_used(_ability: Ability) -> void:
	abilities_played_this_turn += 1
	if abilities_played_this_turn > player_stats.maximum_action_points:
		print("Greedy...")	


func _on_ability_ui_reparent_requested(child: AbilitySlot) -> void:
	child.disabled = true
	child.reparent(self)
	move_child.call_deferred(child, child.original_index)
	child.set_deferred("disabled", false)
