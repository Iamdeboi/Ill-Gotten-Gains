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
@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var treasure_button: Button = %TreasureButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton

var character: PlayerStats


func _ready() -> void:
	if not run_startup:
		return
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.selected_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("TODO: load previous RUN")


func _start_run() -> void:
	_setup_event_connections()
	map.generate_new_map()
	map.unlock_floor(0)


func _change_view(scene: PackedScene) -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()


func _show_map() -> void: #Called when exiting most rooms in the game
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	map.show_map()
	map.unlock_next_rooms()


func _setup_event_connections() -> void:
	EventBus.battle_won.connect(_change_view.bind(BATTLE_REWARDS_SCENE))
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

func _on_battle_won() -> void:
	print("TODO: Conifgure battle_rewards_scene and battle_scene scripts to this one")


func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_change_view(BATTLE_SCENE)
		Room.Type.TREASURE:
			_change_view(TREASURE_ROOM_SCENE)
		Room.Type.CAMPFIRE:
			_change_view(CAMPFIRE_SCENE)
		Room.Type.SHOP:
			_change_view(SHOP_SCENE)
		Room.Type.BOSS:
			_change_view(BATTLE_SCENE)
