class_name PlayerStats
extends BaseStats

signal attributes_changed #To notify UI about attribute value changes

@export_category("Player Combat Features")
@export var maximum_action_points : int
@export var starting_abilities : AbilityList #Abilities given at the start of a run dependant on class selected

@export_category("Player Attributes")
@export var start_strength : int
@export var start_dexterity : int
@export var start_intellect : int
@export var start_wisdom : int
@export var start_charisma : int
@export var start_constitution : int

var action_points : int : set = set_action_points
var known_abilities : AbilityList # All abilities known, starting with the chosen class's starting_abilities
var prepared_abilities : AbilityList # Abilities selected for the hotbar, should not be more than 10
var strength: int : set = set_str
var dexterity: int : set = set_dex
var intellect: int : set = set_int
var wisdom: int : set = set_wis
var charisma: int : set = set_cha
var constituion: int : set = set_con

#Setting Functions:
func set_str(value: int) -> void:
	strength = clampi(value, 0, 999)
	attributes_changed.emit()

func set_dex(value: int) -> void:
	dexterity = clampi(value, 0, 999)
	attributes_changed.emit()

func set_int(value: int) -> void:
	intellect = clampi(value, 0, 999)
	attributes_changed.emit()

func set_wis(value: int) -> void:
	wisdom = clampi(value, 0, 999)
	attributes_changed.emit()

func set_cha(value: int) -> void:
	charisma = clampi(value, 0, 999)
	attributes_changed.emit()

func set_con(value: int) -> void:
	constituion = clampi(value, 0, 999)
	attributes_changed.emit()

func set_action_points(value: int) -> void:
	action_points = value
	stats_changed.emit()

func reset_action_points() -> void:
	self.action_points = maximum_action_points


func can_play_ability(ability: Ability) -> bool:
	if self.action_points <= 0:
		return false
	else:
		match ability.cost_type:
			ability.CostType.MANA:
				return mana >= ability.cost
			ability.CostType.HEALTH:
				return health >= ability.cost
			ability.CostType.GOLD:
				return true
			_:
				return false


func create_instance() -> Resource:
	var instance : PlayerStats = self.duplicate()
	# Base Stats Instances and Setup
	instance.health = max_health
	instance.armor = starting_armor
	instance.mana = max_mana
	# AbilityList Instances and Setup
	instance.known_abilities = instance.starting_abilities.duplicate()
	instance.prepared_abilities = instance.starting_abilities.duplicate()
	# Action Point Instances + Setup
	instance.action_points = maximum_action_points
	instance.reset_action_points()
	# Attribute Instances and Setup
	instance.strength = start_strength
	instance.dexterity = start_dexterity
	instance.intellect = start_intellect
	instance.wisdom = start_wisdom
	instance.charisma = start_charisma
	instance.constituion = start_constitution
	return instance
