extends Node2D

@export var char_stats: PlayerStats

@onready var player_handler: Node = $PlayerHandler
@onready var enemy_handler: Node2D = $EnemyHandler
@onready var player: Player = $Player


func _on_win_button_pressed() -> void:
	EventBus.battle_won.emit()
