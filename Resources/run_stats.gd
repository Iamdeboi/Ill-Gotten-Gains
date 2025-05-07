class_name RunStats
extends Resource

signal gold_changed

const STARTING_GOLD := 50
const BASE_ABILITY_DROPS := 3 # Number of abilities that will appear when theres a reward prompt
const BASE_ATTACK_ABILITY_WEIGHT := 2.5
const BASE_DEFENSE_ABILITY_WEIGHT := 2.5
const BASE_BUFF_ABILITY_WEIGHT := 2.5
const BASE_DEBUFF_ABILITY_WEIGHT := 2.5

@export var gold := STARTING_GOLD : set = set_gold
@export var ability_rewards := BASE_ABILITY_DROPS
@export_range(0.0, 10.0) var attack_weight := BASE_ATTACK_ABILITY_WEIGHT
@export_range(0.0, 10.0) var defense_weight := BASE_DEFENSE_ABILITY_WEIGHT
@export_range(0.0, 10.0) var buff_weight := BASE_BUFF_ABILITY_WEIGHT
@export_range(0.0, 10.0) var debuff_weight := BASE_DEBUFF_ABILITY_WEIGHT


func set_gold(new_amount: int) -> void:
	gold = new_amount
	gold_changed.emit()


func reset_weights() -> void:
	attack_weight = BASE_ATTACK_ABILITY_WEIGHT
	defense_weight = BASE_DEFENSE_ABILITY_WEIGHT
	buff_weight = BASE_BUFF_ABILITY_WEIGHT
	debuff_weight = BASE_DEBUFF_ABILITY_WEIGHT
