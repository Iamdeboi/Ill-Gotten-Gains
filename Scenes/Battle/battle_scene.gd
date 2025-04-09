extends Node2D

@export var player_stats: PlayerStats #Only place where character stats needs to be for the rest of the scene
@export var music: AudioStream

@onready var player_handler: Node = $PlayerHandler
@onready var enemy_handler: Node2D = $EnemyHandler
@onready var player: Player = $Player
@onready var battle_ui: BattleUI = $BattleUI


func _ready() -> void:
	# Temporary debug solution to loading stats; should be done in the Run.gd script once done
	
	var new_stats: PlayerStats = player_stats.create_instance()
	player.stats = new_stats
	battle_ui.player_stats = new_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	EventBus.enemy_turn_ended.connect(_on_enemy_turn_ended)
	EventBus.player_turn_ended.connect(player_handler.end_turn)
	EventBus.player_end_turn_delay_elasped.connect(enemy_handler.start_turn)
	EventBus.player_died.connect(_on_player_died)
	
	start_battle(new_stats)


func start_battle(stats: PlayerStats) -> void:
	MusicPlayer.play(music, true)
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(stats)


func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		print("A Winner is You!")


func _on_win_button_pressed() -> void:
	EventBus.battle_won.emit()


func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()


func _on_player_died() -> void:
	print("Game Over!")
