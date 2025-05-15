class_name ItemData
extends Resource

enum Rarity {BASE, COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC}
enum ItemType {JUNK, TREASURE, CONSUMABLE, KEY_ITEM, HEAD, CHEST, LEGS, TRINKET, MAIN_HAND, OFF_HAND, TWO_HAND}

@export var item_name : String = ""
@export var item_texture : Texture
@export var item_rarity: Rarity
@export var item_type: ItemType
@export var item_type_string: String
@export var item_gold_value: int = 0
@export var stack_size : int = 1
@export var item_description: String = ""
@export var item_effect = ""
