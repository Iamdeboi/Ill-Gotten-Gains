class_name ItemData
extends Resource

enum Type {JUNK, TREASURE, CONSUMABLE, KEY_ITEM, HELM, CHEST, LEGS, TRINKET, MAIN_HAND, OFF_HAND, TWO_HAND}

@export_group("Item Attributes")
@export var item_uid: String
@export var name: String
@export_multiline var description: String
@export var gold_value: int

@export_group("Item Visuals")
@export var icon: Texture
@export var pickup_audio: AudioStream #Sound when clicking and dragging an item
@export var drop_audio: AudioStream #Sound when dropping an item somewhere in the menus
