@tool
class_name ItemReward
extends Control

@export var item_data: ItemData : set = _set_item_data
@export var count: int = 1
@export var pick_up_noise : AudioStream : set = _set_pick_up_noise


func _ready() -> void:
	if Engine.is_editor_hint():
		return


func _set_item_data(value: ItemData) -> void:
	item_data = value
	pass


func _set_pick_up_noise(value: AudioStream) -> void:
	pick_up_noise = value
	pass


func _on_pressed() -> void:
	if item_data:
		if PlayerInventory.PLAYER_INVENTORY_DATA.add_item(item_data, count):
				item_picked_up(item_data)


func item_picked_up(data: ItemData) -> void:
	SfxPlayer.play(pick_up_noise)
