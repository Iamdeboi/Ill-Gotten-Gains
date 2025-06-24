class_name RunStats
extends Resource

signal gold_changed

const STARTING_GOLD := 50
# Ability drops and weights (based on ability type, rather than true rarity)
const BASE_ABILITY_DROPS := 3 # Number of abilities that will appear when theres a reward prompt
const BASE_COMMON_ABILITY_WEIGHT := 6.0
const BASE_UNCOMMON_ABILITY_WEIGHT := 3.7
const BASE_RARE_ABILITY_WEIGHT := 0.3

@export var gold := STARTING_GOLD : set = set_gold

@export_category("Ability Rewards and Weights")
@export var ability_rewards := BASE_ABILITY_DROPS
@export_range(0.0, 10.0) var common_ability_weight := BASE_COMMON_ABILITY_WEIGHT
@export_range(0.0, 10.0) var uncommon_ability_weight := BASE_UNCOMMON_ABILITY_WEIGHT
@export_range(0.0, 10.0) var rare_ability_weight := BASE_RARE_ABILITY_WEIGHT


func set_gold(new_amount: int) -> void:
	gold = new_amount
	gold_changed.emit()


func reset_ability_weights() -> void:
	common_ability_weight = BASE_COMMON_ABILITY_WEIGHT
	uncommon_ability_weight = BASE_UNCOMMON_ABILITY_WEIGHT
	rare_ability_weight = BASE_RARE_ABILITY_WEIGHT
