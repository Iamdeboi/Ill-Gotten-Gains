class_name MapGenerator
extends Node

const X_DIST := 30 # X Margin for map nodes
const Y_DIST := 25 # Y Margin for map nodes
const PLACEMENT_RANDOMNESS := 5 # Trick for making the nodes' placement more organic
const FLOORS := 15 # Rows
const MAP_WIDTH := 7 # Columns
const PATHS := 6 # Maximum number of paths for the whole map
const MONSTER_ROOM_WEIGHT := 10.0 
const SHOP_ROOM_WEIGHT := 2.5
const CAMPFIRE_ROOM_WEIGHT := 4.0

var random_room_type_weights = {
	Room.Type.MONSTER: 0.0,
	Room.Type.CAMPFIRE: 0.0,
	Room.Type.SHOP: 0.0
}

var random_room_type_total_weight := 0
var map_data: Array[Array] #Matrix of the map data; map_data[14][3] = row 15, column 4


func _ready() -> void:
	generate_map()


#GENERATING THE MAP AFTER GRID GENERATION
func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	
	var i := 0
	for floor in map_data: #Checks if the Grid Generator is working properly
		print("floor %s:\t%s" % [i, floor])
		i += 1
	
	return []

#INITIAL GRID GENERATION
func _generate_initial_grid() -> Array[Array]: 
	var result: Array[Array] = []
	
	for i in FLOORS: #i = row
		var adjacent_rooms: Array[Room] = []
		
		for j in MAP_WIDTH: # j = column
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []
			
			# Boss room has a defined spot on the map! The addition of 1 makes more room for the boss room on the map, makes it stand out
			if i == FLOORS - 1:
				current_room.position.y = (i + 1) * Y_DIST
			
			adjacent_rooms.append(current_room) #This will complete 7 times per loop, when all nodes are accounted for in a floor
			
		result.append(adjacent_rooms) #Floor complete, repeat for 15 floors total!
	
	return result
	
	
	
	
	
	
	
