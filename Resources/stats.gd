class_name Stats
extends Resource


signal stats_changed #Notifies UI about stat changes

@export var max_health := 1
@export var art: Texture

var health: int : set = set_health
var armor: int : set = set_armor


func set_health(value : int) -> void:
	health = clampi(value, 0, max_health) # the value recieved can't let the health go under 0 or above max_health
	stats_changed.emit()


func set_armor(value : int) -> void:
	health = clampi(value, 0, 999) # the value recieved can't let the health go under 0 or above max_health
	stats_changed.emit()


func take_damage(damage : int) -> void: # Processes armor before taking the true amount of damage to the entity's health
	if damage <= 0:
		return
	var initial_damage = damage
	damage = clampi(damage - armor, 0, damage)
	self.armor = clampi(armor - initial_damage, 0, armor)
	self.health -= damage


func heal(amount : int) -> void: # Restores health based on amount passed through the method "Stats.heal"
	self.health += amount



func create_instance() -> Resource: # Makes individual instances of entity's with this class
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	return instance

# [Create new resources with this class: "Stats" and "stats.gd" in the inspector]
# [You can set the health and the texture in the inspector tool for every new entity you want to make!]
