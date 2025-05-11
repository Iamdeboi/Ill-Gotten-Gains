class_name JSONData
extends Node

var item_data : Dictionary #All data is stored in this dictionary var, translated from a JSON file

func _ready() -> void:
	item_data = load_data("res://Data/ItemData.json")


func load_data(file_path: String):
	var file_data = FileAccess.open(file_path, FileAccess.READ)
	var json_data = JSON.new()
	json_data.parse(file_data.get_as_text())
	file_data.close()
	return json_data.data
