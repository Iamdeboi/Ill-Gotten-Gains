class_name PlayerStats
extends BaseStats

signal attributes_changed #To notify UI about attribute value changes

@export_category("Player Attributes")
@export var start_strength : int
@export var start_dexterity : int
@export var start_intellect : int
@export var start_wisdom : int
@export var start_charisma : int
@export var start_constitution : int

var strength: int : set = set_str
var dexterity: int : set = set_dex
var intellect: int : set = set_int
var wisdom: int : set = set_wis
var charisma: int : set = set_cha
var constituion: int : set = set_con

#Setting Functions:
func set_str(value: int) -> void:
	strength = clampi(value, 0, 999)
	attributes_changed.emit()

func set_dex(value: int) -> void:
	dexterity = clampi(value, 0, 999)
	attributes_changed.emit()

func set_int(value: int) -> void:
	intellect = clampi(value, 0, 999)
	attributes_changed.emit()

func set_wis(value: int) -> void:
	wisdom = clampi(value, 0, 999)
	attributes_changed.emit()

func set_cha(value: int) -> void:
	charisma = clampi(value, 0, 999)
	attributes_changed.emit()

func set_con(value: int) -> void:
	constituion = clampi(value, 0, 999)
	attributes_changed.emit()


func create_instance() -> Resource:
	var instance : PlayerStats = self.duplicate()
	instance.health = max_health
	instance.armor = starting_armor
	instance.mana = max_mana
	instance.strength = start_strength
	instance.dexterity = start_dexterity
	instance.intellect = start_intellect
	instance.wisdom = start_wisdom
	instance.charisma = start_charisma
	instance.constituion = start_constitution
	return instance
