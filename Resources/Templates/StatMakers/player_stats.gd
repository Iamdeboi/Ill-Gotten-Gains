class_name PlayerStats
extends BaseStats


@export_category("Player Combat Features")
@export var maximum_action_points : int = 3
@export var starting_abilities : AbilityList #Abilities given at the start of a run dependant on class selected
@export var draftable_abilities : AbilityList # List of available abilities to be dropped when winning combats as this class

var action_points : int : set = set_action_points
var known_abilities : AbilityList # All abilities known, starting with the chosen class's starting_abilities
var prepared_abilities : AbilityList # Abilities selected for the hotbar, should not be more than 10


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
	# BaseStats: Core Stats
	instance.health = max_health
	instance.armor = starting_armor
	instance.mana = max_mana
	# BaseStats: Element Vulnerabilities
	instance.physical_vuln = starting_physical_vuln
	instance.fire_vuln = starting_fire_vuln
	instance.frost_vuln = starting_frost_vuln
	instance.storm_vuln = starting_storm_vuln
	instance.toxic_vuln = starting_toxic_vuln
	instance.arcane_vuln = starting_arcane_vuln
	instance.shadow_vuln = starting_shadow_vuln
	instance.holy_vuln = starting_holy_vuln
	# AbilityList Instances and Setup
	instance.known_abilities = instance.starting_abilities.duplicate() # All known abilities a player has
	instance.prepared_abilities = instance.starting_abilities.duplicate() # Abilities found in the hotbar selection, and are able to be used in combat
	# Action Point Instances + Setup
	instance.action_points = maximum_action_points
	instance.reset_action_points()
	# Attribute Instances and Setup
	instance.strength = start_strength
	instance.dexterity = start_dexterity
	instance.intellect = start_intellect
	instance.wisdom = start_wisdom
	instance.charisma = start_charisma
	instance.constitution = start_constitution
	return instance
