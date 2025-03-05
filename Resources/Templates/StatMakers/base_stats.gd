class_name BaseStats
extends Resource

signal stats_changed #Notifies UI about stat changes

@export_category("Starting Values")
@export var max_health: int = 1
@export var starting_armor: int = 1
@export var max_mana: int = 1


var health: int : set = set_health
var mana: int : set = set_mana
var armor: int : set = set_armor


# Setting Functions
func set_health(value : int) -> void:
	health = clampi(value, 0, max_health) # the value recieved can't let the health go under 0 or above max_health
	stats_changed.emit()


func set_mana(value : int) -> void:
	mana = clampi(value, 0, max_mana) # the value recieved can't let the health go under 0 or above max_health
	stats_changed.emit()


func set_armor(value : int) -> void:
	armor = clampi(value, 0, 999) # the value recieved can't let the health go under 0 or above max_health
	stats_changed.emit()

# Stat Changing Functions
func take_damage(damage : int) -> void: # Processes armor before taking the true amount of damage to the entity's health
	if damage <= 0:
		return
	var initial_damage = damage
	damage = clampi(damage - armor, 0, damage)
	self.armor = clampi(armor - initial_damage, 0, armor)
	self.health -= damage


func heal(amount : int) -> void: # Restores health based on amount passed through the method "BaseStats.heal"
	self.health += amount


func restore_mana(amount : int) -> void: #Restores mana based on value
	mana = clampi(amount, 0, max_mana)
	self.mana += amount


func create_instance() -> Resource: #Allows for individual instances of the stats for enemies or the player character (which will be saved after combat and reappplied in the next instance via code)
	var instance: BaseStats = self.duplicate()
	instance.health = max_health
	instance.armor = starting_armor
	instance.mana = max_mana
	return instance
