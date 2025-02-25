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


#GENERATING THE MAP AFTER GRID GENERATION
func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()
	
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1: #Loops from index 0 to 14
			current_j = _setup_connection(i, current_j)
	
	# Once generated, setup respective rooms and their types from node network
	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()
	
	return map_data

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
				current_room.position.y = (i + 1) * -Y_DIST
			
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
			if next_room.column > room.column:
				return true
	
	return false


func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5) #Define the middle column of the map
	var boss_room := map_data[FLOORS - 1][middle] as Room #cast boss room to middle position
	
	for j in MAP_WIDTH: #Connect all rooms below to boss room to the boss room itself
		var current_room = map_data[FLOORS - 2][j] as Room
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)
			
	boss_room.type = Room.Type.BOSS


func _setup_random_room_weights() -> void: #Assigns weights to the assignment of room types, total weight would be the SHOP assignment
	random_room_type_weights[Room.Type.MONSTER] = MONSTER_ROOM_WEIGHT
	random_room_type_weights[Room.Type.CAMPFIRE] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT
	random_room_type_weights[Room.Type.SHOP] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT + SHOP_ROOM_WEIGHT
	
	random_room_type_total_weight = random_room_type_weights[Room.Type.SHOP]


func _setup_room_types() -> void:
	#first floor is always a battle:
	for room: Room in map_data[0]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.MONSTER
	
	# 9th floor is always a treasure room
	for room: Room in map_data[8]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.TREASURE
	
	# Last floor before the boss will always be a campfire (maybe a point of retreat too, as a later project)
	for room: Room in map_data[13]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.CAMPFIRE
	
	# Other rooms
	for current_floor in map_data:
		for room: Room in current_floor:
			for next_room: Room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED: #If room type not assigned by the other methods...
					_set_room_randomly(next_room) #Run the randomizer function for this room


func _set_room_randomly(room_to_set: Room) -> void:
	var campfire_below_4 := true #No campfires beflow floor 4
	var consecutive_campfire := true
	var consecutive_shop := true
	var campfire_on_13 := 13 # No campfires right before the boss-room prep campfire (assigned earlier)
	
	var type_candidate: Room.Type
	
	while campfire_below_4 or consecutive_campfire or consecutive_shop or campfire_on_13:
		type_candidate = _get_random_room_type_by_weight()
		
		var is_campfire := type_candidate == Room.Type.CAMPFIRE
		var has_campfire_parent := _room_has_parent_of_type(room_to_set, Room.Type.CAMPFIRE) # Returns a boolean that checks if room's parent is CAMPFIRE
		var is_shop := type_candidate == Room.Type.SHOP
		var has_shop_parent := _room_has_parent_of_type(room_to_set, Room.Type.SHOP)  # Returns a boolean that checks if room's parent is SHOP
		
		campfire_below_4 = is_campfire and room_to_set.row < 3 # Only true if the room is a campfire, and is below row index 3
		consecutive_campfire = is_campfire and has_campfire_parent
		consecutive_shop = is_shop and has_shop_parent
		campfire_on_13 = is_campfire and room_to_set.row == 12
	
	room_to_set.type = type_candidate

func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool: #Edge Cases: no parents on first floor, no parent at leftmost and rightmost sides of grid
	var parents: Array[Room] = []
	# Left parent check
	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	# Parent below check
	if room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	# Right parent check
	if room.column < MAP_WIDTH - 1 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)

	for parent: Room in parents: # Check if parent type matches the type we wish to assign
		if parent.type == type: # Example: if parent.Room.type == the Room.Type we want
			return true
	
	return false


func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)
	
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	
	return Room.Type.MONSTER
