class_name CharacterStats
extends Stats #shares all related functions to the Stats class above!

@export var max_mana: int
@export var weight_limit: int

var mana: int : set = set_mana
var weight : set = set_weight


func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()


func reset_mana() -> void:
	self.mana = max_mana


func set_weight(value: int) -> void: # Changes weight in cases where the player deposits or withdraws something from their inventory
	weight = value
	stats_changed.emit()


func reset_weight() -> void:
	self.weight = weight_limit

#func can_pickup_item(pickup: Pickup) -> bool:
#	return weight


func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.armor = 0
	instance.reset_mana()
	instance.weight = weight_limit
	return instance
