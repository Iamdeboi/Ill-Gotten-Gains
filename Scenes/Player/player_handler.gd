class_name PlayerHandler
extends Node

const HOTBAR_PLACEMENT_INTERVAL := 0.15


@export var ability_container: AbilityContainer

var player: PlayerStats


func start_battle(player_stats: PlayerStats) -> void:
	player = player_stats
	player.prepared_abilities = player.prepared_abilities.duplicate(true)
	set_up_hotbar(player.prepared_abilities.abilities.size())
	start_turn()


func set_up_ability_slot() -> void:
	ability_container.add_ability(player.prepared_abilities.place_ability_slot())

func start_turn() -> void:
		player.armor = player.starting_armor #At every turn, replenish your armor equal to your starting_armor variable + additional_armor from equipment (TODO)
		player.reset_action_points()

func set_up_hotbar(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(set_up_ability_slot)
		tween.tween_interval(HOTBAR_PLACEMENT_INTERVAL)
		
	tween.finished.connect(
		func(): EventBus.player_hotbar_loaded.emit()
	)
