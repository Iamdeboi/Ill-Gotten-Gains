extends Node

const PLAYER_SCENE = preload("res://Scenes/Player/player.tscn")

var player : Player : set = _set_player


func _set_player(player_ref :Player) -> void:
	if player_ref:
		player = player_ref
		print("Player's ref has been set")
