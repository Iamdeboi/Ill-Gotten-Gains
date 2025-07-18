class_name Ability
extends Resource

enum AbilityType {ATTACK, DEFENSE, BUFF, DEBUFF}
enum Rarity {COMMON, UNCOMMON, RARE}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}
enum CostType {MANA, HEALTH, GOLD}
enum ElementType {NONE, PHYSICAL, FIRE, FROST, STORM, TOXIC, ARCANE, SHADOW, HOLY}
enum Scaling {NONE, STRENGTH, DEXTERITY, INTELLECT, WISDOM, CHARISMA, CONSTITUTION}

const RARITY_COLORS := {
	Ability.Rarity.COMMON: Color.WHITE,
	Ability.Rarity.UNCOMMON: Color.GREEN,
	Ability.Rarity.RARE: Color.BLUE
}

@export_group("Ability Attributes")
@export var id: String
@export var ability_type: AbilityType
@export var rarity: Rarity
@export var target: Target
@export var cost: int
@export var cost_type: CostType
@export var cooldown: int
@export var primary_scaling: Scaling
@export var ps_factor: float = 1
@export var secondary_scaling: Scaling
@export var ss_factor: float = 1
@export var element_type : ElementType

@export_group("Ability Visuals")
@export var icon: Texture
@export var title: String
@export_multiline var tooltip_text: String
@export var sound: AudioStream
@export var pickup_audio: AudioStream
@export var aiming_audio: AudioStream

var primary_scaling_mod: float = 0
var secondary_scaling_mod: float = 0


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


func play(targets: Array[Node], player_stats: PlayerStats, ability: Ability, modifiers: ModifierHandler) -> void:
	EventBus.ability_used.emit(self)
	player_stats.action_points -= 1
	match cost_type:
		CostType.MANA:
			player_stats.mana -= cost
		CostType.HEALTH:
			player_stats.health -= cost
		CostType.GOLD:
			print("You will spend %s gold pieces" % cost)
	
	# Calculate Primary Scaling Damage Mod
	match primary_scaling:
		Scaling.NONE:
			pass
		Scaling.STRENGTH:
			primary_scaling_mod = player_stats.strength * ps_factor
		Scaling.DEXTERITY:
			primary_scaling_mod = player_stats.dexterity * ps_factor
		Scaling.INTELLECT:
			primary_scaling_mod = player_stats.intellect * ps_factor
		Scaling.CHARISMA:
			primary_scaling_mod = player_stats.charisma * ps_factor
		Scaling.WISDOM:
			primary_scaling_mod = player_stats.wisdom * ps_factor
		Scaling.CONSTITUTION:
			primary_scaling_mod = player_stats.constitution * ps_factor
	# Calculate Secondary Scaling Damage Mod
	match secondary_scaling:
		Scaling.NONE:
			pass
		Scaling.STRENGTH:
			secondary_scaling_mod = player_stats.strength * ss_factor
		Scaling.DEXTERITY:
			secondary_scaling_mod = player_stats.dexterity * ss_factor
		Scaling.INTELLECT:
			secondary_scaling_mod = player_stats.intellect * ss_factor
		Scaling.CHARISMA:
			secondary_scaling_mod = player_stats.charisma * ss_factor
		Scaling.WISDOM:
			secondary_scaling_mod = player_stats.wisdom * ss_factor
		Scaling.CONSTITUTION:
			secondary_scaling_mod = player_stats.constitution * ss_factor
			
	if is_single_targeted():
		apply_effects(targets, ability, primary_scaling_mod, secondary_scaling_mod, modifiers)
	else:
		apply_effects(_get_targets(targets), ability, primary_scaling_mod, secondary_scaling_mod, modifiers)
	print("player_stats: " + str(player_stats.health) + " " + str(player_stats.mana) + " " + str(player_stats.armor) + ".")
	EventBus.any_player_action_done.emit()


func apply_effects(_targets: Array[Node], _ability: Ability, _primary_scaling_mod: float, _secondary_scaling_mod: float, _modifiers: ModifierHandler) -> void:
	pass #Each individual ability has their own overidden version of this function, this is a "virtual function"


func update_tooltip(_stats: PlayerStats) -> String:
	return ""
