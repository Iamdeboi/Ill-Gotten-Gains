class_name RunStats
extends Resource

signal gold_changed

const STARTING_GOLD := 50
# Ability drops and weights (based on ability type, rather than true rarity)
const BASE_ABILITY_DROPS := 3 # Number of abilities that will appear when theres a reward prompt
const BASE_ATTACK_ABILITY_WEIGHT := 2.5
const BASE_DEFENSE_ABILITY_WEIGHT := 2.5
const BASE_BUFF_ABILITY_WEIGHT := 2.5
const BASE_DEBUFF_ABILITY_WEIGHT := 2.5
# Item drops and weights based on their rarity
const BASE_ITEM_DROPS := 3
const BASE_COMMON_WEIGHT := 0
const BASE_UNCOMMON_WEIGHT := 0
const BASE_RARE_WEIGHT := 0
const BASE_EPIC_WEIGHT := 0
const BASE_LEGENDARY_WEIGHT := 0
const BASE_MYTHIC_WEIGHT := 0

@export var gold := STARTING_GOLD : set = set_gold

@export_category("Ability Rewards and Weights")
@export var ability_rewards := BASE_ABILITY_DROPS
@export_range(0.0, 10.0) var attack_weight := BASE_ATTACK_ABILITY_WEIGHT
@export_range(0.0, 10.0) var defense_weight := BASE_DEFENSE_ABILITY_WEIGHT
@export_range(0.0, 10.0) var buff_weight := BASE_BUFF_ABILITY_WEIGHT
@export_range(0.0, 10.0) var debuff_weight := BASE_DEBUFF_ABILITY_WEIGHT
@export_range(0.0, 100.0) var common_item_weight := BASE_COMMON_WEIGHT
@export_category("Item Rewards and Weights")
@export var item_rewards := BASE_ITEM_DROPS
@export_range(0.0, 100.0) var uncommon_item_weight := BASE_UNCOMMON_WEIGHT
@export_range(0.0, 100.0) var rare_item_weight := BASE_RARE_WEIGHT
@export_range(0.0, 100.0) var epic_item_weight := BASE_EPIC_WEIGHT
@export_range(0.0, 100.0) var legendary_item_weight := BASE_LEGENDARY_WEIGHT
@export_range(0.0, 100.0) var mythic_item_weight := BASE_MYTHIC_WEIGHT

func set_gold(new_amount: int) -> void:
	gold = new_amount
	gold_changed.emit()


func reset_ability_weights() -> void:
	attack_weight = BASE_ATTACK_ABILITY_WEIGHT
	defense_weight = BASE_DEFENSE_ABILITY_WEIGHT
	buff_weight = BASE_BUFF_ABILITY_WEIGHT
	debuff_weight = BASE_DEBUFF_ABILITY_WEIGHT

func reset_item_weights() -> void:
	common_item_weight = BASE_COMMON_WEIGHT
	uncommon_item_weight = BASE_UNCOMMON_WEIGHT
	rare_item_weight = BASE_RARE_WEIGHT
	epic_item_weight = BASE_EPIC_WEIGHT
	legendary_item_weight = BASE_LEGENDARY_WEIGHT
	mythic_item_weight = BASE_MYTHIC_WEIGHT
