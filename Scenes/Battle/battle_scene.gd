extends Node2D

@export var player_stats: PlayerStats #Only place where character stats needs to be for the rest of the scene

@onready var player_handler: Node = $PlayerHandler
@onready var enemy_handler: Node2D = $EnemyHandler
@onready var player: Player = $Player


func _on_win_button_pressed() -> void:
	EventBus.battle_won.emit()
