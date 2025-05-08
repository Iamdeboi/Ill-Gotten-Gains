class_name AbilityHotbar
extends Control

@export var player_stats: PlayerStats

@onready var ability_slot := preload("res://Scenes/AbilityUI/ability_slot.tscn")

@onready var hotbar_one: GridContainer = %HotbarOne
@onready var hotbar_two: GridContainer = %HotbarTwo
@onready var hotbar_three: GridContainer = %HotbarThree
@onready var hotbar_one_button: TextureButton = %HotbarOneButton
@onready var hotbar_two_button: TextureButton = %HotbarTwoButton
@onready var hotbar_three_button: TextureButton = %HotbarThreeButton

var abilities_played_this_turn := 0
var hotbar_one_array : AbilityList
var hotbar_two_array : AbilityList
var hotbar_three_array : AbilityList


func _ready() -> void:
	EventBus.ability_used.connect(_on_ability_used)
	update_prepared_ability_hotbar()


func update_prepared_ability_hotbar() -> void:
	var original_list = player_stats.prepared_abilities
	hotbar_one_array = original_list.slice
	print(hotbar_one_array)


func slot_prepared_abilities(prepared_abilities: AbilityList) -> void:
	for ability in hotbar_one_array:
		if ability == null:
			continue
		add_ability(ability)


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


func _on_hotbar_one_button_pressed() -> void:
	hotbar_one.show()
	hotbar_two.hide()
	hotbar_three.hide()


func _on_hotbar_two_button_pressed() -> void:
	hotbar_one.hide()
	hotbar_two.show()
	hotbar_three.hide()


func _on_hotbar_three_button_pressed() -> void:
	hotbar_one.hide()
	hotbar_two.hide()
	hotbar_three.show()
