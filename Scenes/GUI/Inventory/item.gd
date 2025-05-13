class_name Item
extends Node2D

@onready var icon: TextureRect = $MarginContainer/Icon
@onready var stack_count: Label = $MarginContainer/StackCount

var item_name : String
var item_quantity : int


func _ready() -> void:
	var rand_val = randi() % 5
	match rand_val:
		0:
			item_name = "Iron Sword"
		1:
			item_name = "Weak Mana Potion"
		2:
			item_name = "Iron Buckler"
		3:
			item_name = "Weak Health Potion"
		4:
			item_name = "Weak Energy Potion"


	icon.texture = load("res://Assets/art/IGGItemIcons/" + str(item_name) + ".png") # Directs to the item asset folder, ensure the name is EXACTLY as in the JSON file!
	var stack_size = int(JsonData.item_data[item_name]["stack_size"]) # This is how you ultlize data for JSON files, here this code uses the "stack_size" data and assigns it to the godot variable of the same name!
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1: # Equipment and Key Items will have only 1 stack_size, and will not show the number
		stack_count.visible = false
	else:
		stack_count.text = str(item_quantity)


func set_item(i_name, i_quantity):
	item_name = i_name
	item_quantity = i_quantity
	icon.texture = load("res://Assets/art/IGGItemIcons/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["stack_size"])
	if stack_size == 1:
		stack_count.visible = false
	else:
		stack_count.visible = true
		stack_count.text = str(item_quantity)


func add_item_quantity(amount_to_add: int) -> void:
	item_quantity += amount_to_add
	stack_count.text = str(item_quantity)


func decrease_item_quantity(amount_to_decrease: int) -> void:
	item_quantity -= amount_to_decrease
	stack_count.text = str(item_quantity)
