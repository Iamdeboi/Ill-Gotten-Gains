class_name Ability
extends Resource

enum Type {SKILL, SPELL}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}
enum CostType {MANA, HEALTH, GOLD}
enum Scaling {STRENGTH, DEXTERITY, INTELLECT, WISDOM, CHARISMA, CONSTITUTION, NONE}

@export_group("Ability Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int
@export var cost_type: CostType
@export var cooldown: int
@export var scaling: Scaling

@export_group("Ability Visuals")
@export var icon: Texture
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


func play(targets: Array[Node], char_stats: PlayerStats) -> void:
	EventBus.ability_used.emit(self)
	match cost_type:
		CostType.MANA:
			char_stats.mana -= cost
		CostType.HEALTH:
			char_stats.health -= cost
		CostType.GOLD:
			pass
	
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))


func apply_effects(_targets: Array[Node]) -> void:
	pass #Each individual card has their own overidden version of this function, this is a "virtual function"
