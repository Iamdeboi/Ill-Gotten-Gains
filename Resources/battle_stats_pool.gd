class_name BattleStatsPool
extends Resource

@export var pool: Array[BattleStats]

var total_weights_by_tier := [0.0, 0.0, 0.0]


func _get_all_battles_for_tier(tier: int) -> Array[BattleStats]:
	return pool.filter(
		func(battle: BattleStats):
			return battle.battle_tier == tier #Anonymous function that ensures that the battle tier of the battle equals the tier of this function
	)


func _setup_weight_for_tier(tier: int) -> void:
	var battles := _get_all_battles_for_tier(tier)
	total_weights_by_tier[tier] = 0.0 # Reset tier array before iterating over all of the battles of a defined tier
	
	for battle: BattleStats in battles:
		total_weights_by_tier[tier] += battle.weight
		battle.accumulated_weight = total_weights_by_tier[tier]


func get_random_battle_for_tier(tier: int) -> BattleStats:
	var roll := randf_range(0.0, total_weights_by_tier[tier])
	var battles := _get_all_battles_for_tier(tier)
	
	for battle: BattleStats in battles:
		if battle.accumulated_weight > roll:
			return battle
	
	return null # No fights found (shouldnt happen)


func setup() -> void:
	for i in 3:
		_setup_weight_for_tier(i)
