class_name MapRoom
extends Area2D

signal selected(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE], #Sprite, Scale
	Room.Type.MONSTER: [preload("res://Assets/art/tile_0103.png"), Vector2.ONE],
	Room.Type.TREASURE: [preload("res://Assets/art/tile_0089.png"), Vector2.ONE],
	Room.Type.CAMPFIRE: [preload("res://Assets/art/player_heart.png"), Vector2(0.6, 0.6)],
	Room.Type.SHOP: [preload("res://Assets/art/gold.png"), Vector2(0.6, 0.6)],
	Room.Type.BOSS: [preload("res://Assets/art/tile_0118.png"), Vector2(1.25, 1.25)],
}

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var room: Room : set = set_room


func set_available(new_value: bool) -> void:
	available = new_value
	
	if available:
		anim_player.play("highlight")
	elif not room.selected:
		anim_player.play("RESET")


func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]


func show_selected() -> void:
	line_2d.modulate = Color.WHITE


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return
	
	room.selected = true
	anim_player.play("select")


# Called by the AnimationPlayer when "select" finishes
# Completess the animation, THEN does the signal function
# Alternatively use await functions, like with the buttons for menu UI
func _on_map_room_selected() -> void:
	selected.emit(room)
