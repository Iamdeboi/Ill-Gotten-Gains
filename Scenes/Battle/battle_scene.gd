extends Node2D

@export var player_stats: PlayerStats #Only place where character stats needs to be for the rest of the scene

@onready var player_handler: Node = $PlayerHandler
@onready var enemy_handler: Node2D = $EnemyHandler
@onready var player: Player = $Player
@onready var battle_ui: BattleUI = $BattleUI


func _ready() -> void:
	# Temporary debug solution to loading stats; should be done in the Run.gd script once done
	
	var new_stats: PlayerStats = player_stats.create_instance()
	player.stats = new_stats
	battle_ui.player_stats = new_stats
	
	start_battle(new_stats)


func start_battle(stats: PlayerStats) -> void:
	player_handler.start_battle(stats)


func _on_win_button_pressed() -> void:
	EventBus.battle_won.emit()
