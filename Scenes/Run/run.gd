class_name Run
extends Node

const BATTLE_SCENE := preload("res://Scenes/Battle/battle_scene.tscn")
const BATTLE_REWARDS_SCENE := preload("res://Scenes/BattleRewards/battle_rewards.tscn")
const CAMPFIRE_SCENE := preload("res://Scenes/Campfire/campfire.tscn")
const SHOP_SCENE := preload("res://Scenes/Shop/shop.tscn")
const TREASURE_ROOM_SCENE := preload("res://Scenes/TreasureRoom/treasure_room.tscn")


@export var run_startup: RunStartup
@onready var map: Map = $Map
@onready var current_view: Node = $CurrentView
#Top-bar UI
@onready var gold_ui: GoldUI = %GoldUI
@onready var top_bar_spell_book: TopBarSpellBook = %TopBarSpellBook
@onready var spellbook_view: AbilityMenuView = %SpellbookView
#Debug Buttons
@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var treasure_button: Button = %TreasureButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton

var run_stats: RunStats # Handles things like Gold, Item Drops, Ability Drops, etc.
var character: PlayerStats # Instance of player's stats throughout the entire run


func _ready() -> void:
	if not run_startup:
		return
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN: # PlayerStats determined by character selection screen choice, an instance is made as your starting stats
			character = run_startup.selected_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN: # Continues the progress on your run
			print("TODO: load previous RUN")


func _start_run() -> void:
	run_stats = RunStats.new()
	
	_setup_event_connections()
	_setup_top_bar()
	
	map.generate_new_map()
	map.unlock_floor(0)


func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	
	return new_view


func _show_map() -> void: #Called when exiting most rooms in the game
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	map.show_map()
	map.unlock_next_rooms()


func _setup_event_connections() -> void:
	EventBus.battle_won.connect(_on_battle_won)
	EventBus.battle_reward_exited.connect(_show_map)
	EventBus.campfire_exited.connect(_show_map)
	EventBus.map_exited.connect(_on_map_exited)
	EventBus.shop_exited.connect(_show_map)
	EventBus.treasure_room_exited.connect(_show_map)
	
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_show_map)
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARDS_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_ROOM_SCENE))


func _setup_top_bar():
	gold_ui.run_stats = run_stats
	top_bar_spell_book.pressed.connect(spellbook_view.show_current_view.bind("Spellbook"))
	spellbook_view.ability_list = character.known_abilities # Update the ability list export for the spellbook_view with the "known_abilities" of the player
	spellbook_view._update_view() # Use the _update_view function to update all abilities with their respective slot scenes and their tooltip integration
	spellbook_view.hide() # cancels out the "show()" at the end of _update_view()
	# TODO: Determine if theres a better way to update the abilities without making a very similar function for the "AbilityMenuView" script...


func _on_battle_room_entered(room: Room) -> void:
	var battle_scene: Battle = _change_view(BATTLE_SCENE) as Battle
	battle_scene.player_stats = character
	battle_scene.battle_stats = room.battle_stats
	battle_scene.start_battle()


func _on_battle_won() -> void:
	var reward_scene := _change_view(BATTLE_REWARDS_SCENE) as BattleRewards
	reward_scene.run_stats = run_stats
	reward_scene.character_stats = character
# Battle Rewards Time! Uses gold reward data from last_room.battle_stats
	reward_scene.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scene.add_ability_reward()


func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.TREASURE:
			_change_view(TREASURE_ROOM_SCENE)
		Room.Type.CAMPFIRE:
			_change_view(CAMPFIRE_SCENE)
		Room.Type.SHOP:
			_change_view(SHOP_SCENE)
		Room.Type.BOSS:
			_on_battle_room_entered(room)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spellbook_button"):
		spellbook_view.visible = !spellbook_view.visible
