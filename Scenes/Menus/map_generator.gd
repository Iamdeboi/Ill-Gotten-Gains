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
	var starting_points := _get_random_starting_points()
	
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1: #Loops from index 0 to 14
			current_j = _setup_connection(i, current_j)
	
	#DEBUGGING CODE: Ensures setting up the connections and avoiding crossing paths is working correctly
	var i := 0
	for floor in map_data:
		print("floor %s" % i)
		var used_rooms = floor.filter(
			func(room: Room): return room.next_rooms.size() > 0
		)
		print(used_rooms)
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


#GENERATING INITIAL STARTING POINT ARRAY
func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 2: #Use 2 as the minimum amount of starting points a player will experience in a map, never 1!
		unique_points = 0
		y_coordinates = []
		for i in PATHS: # Repeats for each unique Node in each floor
			var starting_point := randi_range(0, MAP_WIDTH - 1) # Indicies would go from 0 to 6 (7 Columns)
			if not y_coordinates.has(starting_point):
				unique_points += 1
			
			y_coordinates.append(starting_point)
	
	return y_coordinates


func _setup_connection(i: int, j: int) -> int:
	var next_room: Room
	var current_room := map_data[i][j] as Room
	#Pick next room if you dont have one, or pick a new candidate if next room would CROSS PATHS...
	while not next_room or _would_cross_existing_path(i, j, next_room):
		#New column index chosen, given a range, yet clamped to the MAP_WIDTH - 1, no negative indicies, and no indicies over MAP_WIDTH!
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j] #Next room will be 1 level above current, and the random_j will be its respective column
		
	#Loop breaks when the next room is found, and is confirmed that it will not cross existing paths, append to the next_room Array!
	current_room.next_rooms.append(next_room)
	
	return next_room.column


func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var left_neighbour: Room
	var right_neighbour: Room
	
	# if j == 0, there is no left neighbour
	if j > 0:
		left_neighbour = map_data[i][j - 1]
	# if j == MAP_WIDTH, there is no right neighbour
	if j < MAP_WIDTH - 1:
		right_neighbour = map_data[i][j + 1]
	
	# Cannot cross right dir if right_neighbour goes left
	if right_neighbour and room.column > j:
		for next_room: Room in right_neighbour.next_rooms:
			if next_room.column < room.column:
				return true
	
	# Cannot cross left dir if left_neighbour goes right
	if left_neighbour and room.column < j:
		for next_room: Room in left_neighbour.next_rooms:
			if next_room.column < room.column:
				return true
	
	return false
