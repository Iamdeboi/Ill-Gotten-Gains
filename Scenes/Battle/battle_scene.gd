class_name Battle
extends Node2D

const VICTORY_THEME := preload("res://Assets/Audio/Jingles_Fanfares_SFX_Pack/Jingles_and_Fanfares/Battle/Battle_Victory_Fanfare.wav")
const DEFEAT_THEME := preload("res://Assets/Audio/Jingles_Fanfares_SFX_Pack/Jingles_and_Fanfares/Battle/Defeat.wav")

@export var battle_stats: BattleStats
@export var player_stats: PlayerStats #Only place where character stats needs to be for the rest of the scene
@export var music: AudioStream

@onready var player_handler: Node = $PlayerHandler
@onready var enemy_handler: Node2D = $EnemyHandler
@onready var player: Player = $BattleUI/Player
@onready var battle_ui: BattleUI = $BattleUI


func _ready() -> void:
	# Temporary debug solution to loading stats; should be done in the Run.gd script once done
	
	#var new_stats: PlayerStats = player_stats.create_instance()
	#player.stats = new_stats
	#battle_ui.player_stats = new_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	EventBus.enemy_turn_ended.connect(_on_enemy_turn_ended)
	EventBus.player_turn_ended.connect(player_handler.end_turn)
	EventBus.player_end_turn_delay_elasped.connect(enemy_handler.start_turn)
	EventBus.player_died.connect(_on_player_died)


func start_battle() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	
	battle_ui.player_stats = player_stats
	player.stats = player_stats
	
	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemy_actions()
	
	player_handler.start_battle(player_stats)
	player.player_stats_ui.update_ability_view_ui(player_stats)


func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		EventBus.battle_over_screen_requested.emit("Combat Won!", BattleOverPanel.Type.WIN)
		MusicPlayer.stop()
		MusicPlayer.play(VICTORY_THEME)


func _on_enemy_turn_ended() -> void:
	await get_tree().create_timer(0.5).timeout
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()


func _on_player_died() -> void:
	await get_tree().create_timer(1).timeout # Delay to ensure all SFX, Tweens, and Animations are done
	EventBus.battle_over_screen_requested.emit("Too Greedy...", BattleOverPanel.Type.LOSE)
	MusicPlayer.stop()
	MusicPlayer.play(DEFEAT_THEME)
