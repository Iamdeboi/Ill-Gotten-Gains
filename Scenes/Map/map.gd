class_name Map
extends Node2D

const SCROLL_SPEED := 25
const MAP_ROOM = preload("res://Scenes/Map/map_room.tscn")
const MAP_LINE = preload("res://Scenes/Map/map_line.tscn")

@onready var map_generator: MapGenerator = $MapGenerator
@onready var lines: Node2D = %Lines # Container node for line children created through methods below
@onready var rooms: Node2D = %Rooms # container node for room children created through methods below
@onready var visuals: Node2D = $Visuals
@onready var camera_2d: Camera2D = $Camera2D

var map_data: Array[Array]
var floors_climbed: int
var last_room: Room
var camera_edge_y: float


func _ready() -> void:
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.FLOORS - 1) #Calculate camera edge


func _input(event: InputEvent) -> void:
	if not visible: # Do not read scroll inputs if the map scene is not meant to be visible (no scrolling in combat, shop, treaasure rooms, etc.)
		return
	
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLL_SPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLL_SPEED
	
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0) # Cant scroll infintely


func generate_new_map() -> void:
	floors_climbed = 0
	map_data = map_generator.generate_map() #Generates array of array
	create_map() 


func create_map() -> void: # Creates the map based on previous data, floor by floor
	for current_floor: Array in map_data:
		for room: Room in current_floor:
			if room.next_rooms.size() > 0: # If next room is not empty, generate a path and spawn room
				_spawn_room(room)
	
	#Boss room has not next room, but needs to spawn
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5) # Column index of boss room
	_spawn_room(map_data[MapGenerator.FLOORS-1][middle]) # Seperate call function for the boss room, not part of the for loop
	
	# Centering map visuals
	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH - 1)
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	visuals.position.y = get_viewport_rect().size.y / 2


func unlock_floor(which_floor: int = floors_climbed) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == which_floor:
			map_room.available = true


func unlock_next_rooms() -> void: #unlocks connected rooms from your current room index
	for map_room: MapRoom in rooms.get_children():
		if last_room.next_rooms.has(map_room.room):
			map_room.available = true


#Utlity Methods:
func show_map() -> void:
	show()
	camera_2d.enabled = true


func hide_map() -> void:
	hide()
	camera_2d.enabled = false


func _spawn_room(room: Room) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)
	
	if room.selected and room.row < floors_climbed:
		new_map_room.show_selected()


func _connect_lines(room: Room) -> void:
	if room.next_rooms.is_empty():
		return
		
	for next: Room in room.next_rooms:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(room.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)


func _on_map_room_selected(room: Room) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false
	
	last_room = room
	floors_climbed += 1
	EventBus.map_exited.emit(room)
