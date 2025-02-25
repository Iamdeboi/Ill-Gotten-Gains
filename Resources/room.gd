class_name Room
extends Resource

enum Type {NOT_ASSIGNED, MONSTER, TREASURE, CAMPFIRE, SHOP, BOSS}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2 
@export var next_rooms: Array[Room]
@export var selected := false 

#DEBUGGING
#func _to_string() -> String: #Instead of a visual, use this to test withiin the console
	#return "%s (%s)" % [column, Type.keys()[type][0]]
	# Only first letter of Type enums, for cleanliness in messaging
	# LOGIC FOR STATEMENT ABOVE:
	# var type = Type.SHOP
		#print(int(type)) #enum values are integers indexed from 0
	# 1. All enum keys as Strings:
		#print(Type.keys())
	# 2. An enum value's name as a String:
		#print(Type.keys()[type])
	# 3. First letter of the String given above:
		#print(Type.keys()[type][0])
