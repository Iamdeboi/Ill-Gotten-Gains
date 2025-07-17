class_name PlayerHandler
extends Node

const HOTBAR_PLACEMENT_INTERVAL := 0.00


@export var player: Player
@export var ability_container: AbilityContainer

var character: PlayerStats
var is_first_turn = true


func start_battle(player_stats: PlayerStats) -> void:
	character = player_stats
	character.armor = character.starting_armor
	# Setting up AbilityContainer(Hotbar)
	ability_container.read_ability_list(player_stats.known_abilities)
	EventBus.player_hotbar_loaded.emit()
	player.status_handler.statuses_applied.connect(_on_statuses_applied)
	start_turn()


func set_up_ability_slot() -> void:
	ability_container.add_ability(character.known_abilities.place_ability_slot())


func start_turn() -> void:
	character.reset_action_points()
	ability_container.enable_hotbar()
	ability_container.abilities_played_this_turn = 0
	player.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
	
	EventBus.player_turn_started.emit()
	if is_first_turn == true:
		is_first_turn = false
		return
	character.armor = 0


func end_turn() -> void:
	ability_container.disable_hotbar()
	player.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)
	await get_tree().create_timer(1).timeout
	EventBus.player_end_turn_delay_elasped.emit()


func _on_statuses_applied(type: Status.Type) -> void:
	match type:
		Status.Type.START_OF_TURN:
			print("Statuses applied at start of turn")
		Status.Type.END_OF_TURN:
			print("Statuses applied at end of turn")
