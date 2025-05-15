class_name InventoryView
extends Control

@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var back_button: Button = %BackButton


func _ready() -> void:
	back_button.pressed.connect(hide)
