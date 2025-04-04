class_name Ability
extends Resource

enum AbilityType {ATTACK, DEFENSE}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}
enum CostType {MANA, HEALTH, GOLD}
enum ElementType {NONE, PHYSICAL, FIRE, FROST, STORM, TOXIC, ARCANE, SHADOW, HOLY}
enum Scaling {NONE, STRENGTH, DEXTERITY, INTELLECT, WISDOM, CHARISMA, CONSTITUTION}

@export_group("Ability Attributes")
@export var id: String
@export var ability_type: AbilityType
@export var target: Target
@export var cost: int
@export var cost_type: CostType
@export var cooldown: int
@export var primary_scaling: Scaling
@export var secondary_scaling: Scaling
@export var element_type : ElementType

@export_group("Ability Visuals")
@export var icon: Texture
@export var title: String
@export_multiline var tooltip_text: String


func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("Player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("Enemy")
		Target.EVERYONE:
			return tree.get_nodes_in_group("Player") + tree.get_nodes_in_group("Enemy")
		_: # default case, return empty array instead of breaking game
			return []


func play(targets: Array[Node], player_stats: PlayerStats, ability: Ability) -> void:
	EventBus.ability_used.emit(self)
	player_stats.action_points -= 1
	match cost_type:
		CostType.MANA:
			player_stats.mana -= cost
		CostType.HEALTH:
			player_stats.health -= cost
		CostType.GOLD:
			print("You will spend %s gold pieces" % cost)
	
	if is_single_targeted():
		apply_effects(targets, ability)
	else:
		apply_effects(_get_targets(targets), ability)
	print("player_stats: " + str(player_stats.health) + " " + str(player_stats.mana) + " " + str(player_stats.armor) + ".")


func apply_effects(_targets: Array[Node], _ability: Ability) -> void:
	pass #Each individual ability has their own overidden version of this function, this is a "virtual function"
