class_name BattleRewards
extends Control

enum Type {GOLD, NEW_ABILITY, TREASURE}

const ABILITY_REWARDS = preload("res://Scenes/AbilityRewards/ability_rewards.tscn")
const REWARD_BUTTON = preload("res://Scenes/BattleRewards/reward_button.tscn")
const GOLD_ICON := preload("res://Assets/art/gold.png")
const GOLD_TEXT := "%s gold"
const ABILITY_ICON := preload("res://Assets/art/tile_0074.png")
const ABILITY_TEXT := "Ability Drop"
const TREASURE_ICON := preload("res://Assets/art/tile_0082.png")
const TREASURE_TEXT := "TREASURE Drop"

@export var run_stats : RunStats
@export var character_stats : PlayerStats

@onready var rewards: VBoxContainer = %Rewards

var ability_reward_total_weight := 0.0
var ability_rarity_weights := {
	Ability.Rarity.COMMON: 0.0,
	Ability.Rarity.UNCOMMON: 0.0,
	Ability.Rarity.RARE: 0.0
}

func _ready() -> void:
	for node: Node in rewards.get_children():
		node.queue_free()
	
	# Test Code, no longer needed!
	#run_stats = RunStats.new()
	#run_stats.gold_changed.connect(func(): print("gold: %s" % run_stats.gold))
	#character_stats = preload("res://Resources/Classes/Warrior/warrior_stats.tres").create_instance()
	#
	#add_gold_reward(69)
	#add_ability_reward()
	#add_ability_reward()


func add_gold_reward(amount: int) -> void:
	var gold_reward := REWARD_BUTTON.instantiate() as RewardsButton #Create a new rewardsbutton scene to set the values
	gold_reward.reward_icon = GOLD_ICON
	gold_reward.reward_text = GOLD_TEXT % amount
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(amount))
	rewards.add_child.call_deferred(gold_reward) # Add to rewards hbox


func add_ability_reward() -> void:
	var ability_reward := REWARD_BUTTON.instantiate() as RewardsButton
	ability_reward.reward_icon = ABILITY_ICON
	ability_reward.reward_text = ABILITY_TEXT
	ability_reward.pressed.connect(_show_ability_rewards)
	rewards.add_child.call_deferred(ability_reward)


func _show_ability_rewards() -> void:
	if not run_stats or not character_stats: # Run stats and player's statblock are essential for this function
		return
	
	var ability_rewards := ABILITY_REWARDS.instantiate() as AbilityRewards
	add_child(ability_rewards)
	ability_rewards.ability_reward_selected.connect(_on_ability_reward_taken)
	
	var ability_reward_array: Array[Ability] = []
	var available_abilities: Array[Ability] = character_stats.draftable_abilities.abilities.duplicate(true)
	
	for i in run_stats.ability_rewards: # Default 3 choices; TODO: introduce some treasures that increase/decrease this value dynamically!
		_setup_ability_chances()
		var roll := randf_range(0.0, ability_reward_total_weight)
		print(roll)
		for rarity: Ability.Rarity in ability_rarity_weights:
			if ability_rarity_weights[rarity] > roll:
				_modify_weights(rarity)
				var picked_ability := _get_random_available_ability(available_abilities, rarity)
				ability_reward_array.append(picked_ability) # Add to reward array
				available_abilities.erase(picked_ability) # Remove it from the draftable cards list to prevent duplicate ability drops
				break
	
	ability_rewards.rewards = ability_reward_array # After all of the possible slots have been iterated over, update the rewards array with the processed choices
	ability_rewards.show()


func _setup_ability_chances() -> void:
	ability_reward_total_weight = run_stats.common_ability_weight + run_stats.uncommon_ability_weight + run_stats.rare_ability_weight
	ability_rarity_weights[Ability.Rarity.COMMON] = run_stats.common_ability_weight
	ability_rarity_weights[Ability.Rarity.UNCOMMON] = run_stats.common_ability_weight + run_stats.uncommon_ability_weight
	ability_rarity_weights[Ability.Rarity.RARE] = ability_reward_total_weight


func _modify_weights(rarity_rolled: Ability.Rarity) -> void:
	if rarity_rolled == Ability.Rarity.RARE:
		run_stats.rare_ability_weight = RunStats.BASE_RARE_ABILITY_WEIGHT # If an attack card was rolled, set the attack_ability chances back to default
	else:
		run_stats.rare_ability_weight = clampf(run_stats.rare_ability_weight + 0.3, run_stats.BASE_RARE_ABILITY_WEIGHT, 5.0) # Else, increase the chances for a new attack card by 3% (0.3 weight), clamped to a chance of 50% total (5.0 weight)


func _get_random_available_ability(available_abilities: Array[Ability], with_rarity: Ability.Rarity) -> Ability:
	var all_possible_abilities := available_abilities.filter(
		func(ability: Ability):
			return ability.rarity == with_rarity
	)
	return all_possible_abilities.pick_random()


func _on_gold_reward_taken(amount: int) -> void:
	if not run_stats:
		return
	
	run_stats.gold += amount


func _on_ability_reward_taken(ability: Ability) -> void:
	if not character_stats or not ability:
		return
		
	print("Spellbook Before:\n%s\n" % character_stats.known_abilities)
	character_stats.known_abilities.add_ability(ability)
	print("Spellbook After:\n%s" % character_stats.known_abilities)
	character_stats.draftable_abilities.abilities.erase(ability)


func _on_back_button_pressed() -> void:
		EventBus.battle_reward_exited.emit()
