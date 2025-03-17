extends Node2D

@export var char_stats: PlayerStats

@onready var player_handler: Node = $PlayerHandler
@onready var enemy_handler: Node2D = $EnemyHandler
@onready var player: Player = $Player
