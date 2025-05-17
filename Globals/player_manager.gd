extends Node

const PLAYER_SCENE = preload("res://Scenes/Player/player.tscn")
const INVENTORY_DATA : InventoryData = preload("res://Scenes/GUI/Inventory/player_inventory.tres")

var player : Player : set = _set_player


func _set_player(player_ref :Player) -> void:
	if player_ref:
		player = player_ref
		print("Player's ref has been set")
