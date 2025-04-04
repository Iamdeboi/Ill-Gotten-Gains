class_name BaseStats
extends Resource

signal stats_changed #Notifies UI about stat changes

@export_category("Starting Values")
@export var max_health: int = 1
@export var starting_armor: int = 1
@export var max_mana: int = 1

@export_category("Data + Assets")
@export var name: String = ""
@export var sprite: Texture

@export_category("Element Vulnerabilities")
@export var starting_physical_vuln : float = 1.0
@export var starting_fire_vuln : float = 1.0
@export var starting_frost_vuln : float = 1.0
@export var starting_storm_vuln : float = 1.0
@export var starting_toxic_vuln : float = 1.0
@export var starting_arcane_vuln : float = 1.0
@export var starting_shadow_vuln : float = 1.0
@export var starting_holy_vuln : float = 1.0

var health: int : set = set_health
var mana: int : set = set_mana
var armor: int : set = set_armor
# Resistances (or vulnerabilities): float value that will be calculated with damage of matching type
var physical_vuln: float : set = set_physical_vuln
var fire_vuln: float : set = set_fire_vuln
var frost_vuln: float : set = set_frost_vuln
var storm_vuln: float : set = set_storm_vuln
var toxic_vuln: float : set = set_toxic_vuln
var arcane_vuln: float : set = set_arcane_vuln
var shadow_vuln: float : set = set_shadow_vuln
var holy_vuln: float : set = set_holy_vuln


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

func set_physical_vuln(value: float) -> void:
	physical_vuln = clampf(value, 0.00, 2.00)
	stats_changed.emit()

func set_fire_vuln(value: float) -> void:
	fire_vuln = clampf(value, 0.00, 2.00)
	stats_changed.emit()

func set_frost_vuln(value: float) -> void:
	frost_vuln = clampf(value, 0.00, 2.00)
	stats_changed.emit()

func set_storm_vuln(value: float) -> void:
	storm_vuln = clampf(value, 0.00, 2.00)
	stats_changed.emit()

func set_toxic_vuln(value: float) -> void:
	toxic_vuln = clampf(value, 0.00, 2.00)
	stats_changed.emit()

func set_arcane_vuln(value: float) -> void:
	arcane_vuln = clampf(value, 0.00, 2.00)
	stats_changed.emit()

func set_shadow_vuln(value: float) -> void:
	shadow_vuln = clampf(value, 0.00, 2.00)
	stats_changed.emit()

func set_holy_vuln(value: float) -> void:
	holy_vuln = clampf(value, 0.00, 2.00)
	stats_changed.emit()


# Stat Changing Functions
func calculate_damage(amount: int, dmg_mod: float) -> int:
	var new_damage = amount * dmg_mod
	return new_damage


func take_damage(damage : int) -> void: # Processes armor before taking the true amount of damage to the entity's health
	if damage <= 0:
		return
	var initial_damage = damage #set a variable of a snapshot of the calculated damage to mitigate with armor
	damage = clampi(initial_damage - armor, 0, damage)
	self.armor = clampi(armor - initial_damage, 0, armor)
	self.health -= damage


func restore_armor(amount : int) -> void:
	self.armor += amount


func heal(amount : int) -> void: # Restores health based on amount passed through the method "BaseStats.heal"
	self.health += clampi(amount, 0, max_health)


func restore_mana(amount : int) -> void: #Restores mana based on value
	mana = clampi(amount, 0, max_mana)
	self.mana += amount


func create_instance() -> Resource: #Allows for individual instances of the stats for enemies or the player character (which will be saved after combat and reappplied in the next instance via code)
	var instance: BaseStats = self.duplicate()
	instance.health = max_health
	instance.armor = starting_armor
	instance.mana = max_mana
	instance.physical_vuln = starting_physical_vuln
	instance.fire_vuln = starting_fire_vuln
	instance.frost_vuln = starting_frost_vuln
	instance.storm_vuln = starting_storm_vuln
	instance.toxic_vuln = starting_toxic_vuln
	instance.arcane_vuln = starting_arcane_vuln
	instance.shadow_vuln = starting_shadow_vuln
	instance.holy_vuln = starting_holy_vuln
	return instance
