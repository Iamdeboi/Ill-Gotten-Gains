class_name BattleRewards
extends Control

const REWARD_BUTTON = preload("res://Scenes/BattleRewards/reward_button.tscn")
const GOLD_ICON := preload("res://Assets/art/gold.png")
const GOLD_TEXT := "%s gold"
const ABILITY_ICON := preload("res://Assets/art/tile_0074.png")
const ABILITY_TEXT := "Ability Drop"
const ITEM_ICON := preload("res://Assets/art/tile_0082.png")
const ITEM_TEXT := "Item Drop"

@export var run_stats : RunStats

@onready var rewards: VBoxContainer = %Rewards


func _ready() -> void:
	for node: Node in rewards.get_children():
		node.queue_free()
	
	run_stats = RunStats.new()
	run_stats.gold_changed.connect(func(): print("gold: %s" % run_stats.gold))
	
	add_gold_reward(69)

func add_gold_reward(amount: int) -> void:
	var gold_reward := REWARD_BUTTON.instantiate() as RewardsButton #Create a new rewardsbutton scene to set the values
	gold_reward.reward_icon = GOLD_ICON
	gold_reward.reward_text = GOLD_TEXT % amount
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(amount))
	rewards.add_child.call_deferred(gold_reward) # Add to rewards hbox

func _on_gold_reward_taken(amount: int) -> void:
	if not run_stats:
		return
	
	run_stats.gold += amount

func _on_back_button_pressed() -> void:
		EventBus.battle_reward_exited.emit()
