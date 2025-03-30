extends Node2D

const ARC_POINTS := 8 #Number of points on curve for the target arrow

@onready var area_2d: Area2D = $Area2D
@onready var ability_arc: Line2D = $CanvasLayer/AbilityArc

var current_ability: AbilitySlot
var targeting := false


func _ready() -> void:
	EventBus.ability_targeting_started.connect(_on_ability_targeting_started)
	EventBus.ability_targeting_ended.connect(_on_ability_targeting_ended)


func _process(delta: float) -> void:
	if not targeting:
		return
	
	area_2d.position = get_local_mouse_position()
	ability_arc.points = _get_points()


func _get_points() -> Array:
	var points := []
	var start := current_ability.global_position
	start.x += (current_ability.size.x / 2)
	var target := get_local_mouse_position()
	var distance := (target - start)
	
	for i in range(ARC_POINTS):
		var t := (1.0 / ARC_POINTS) * i
		var x := start.x + (distance.x / ARC_POINTS) * i
		var y := start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x, y))
	
	points.append(target)
	
	return points


func ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)


func _on_ability_targeting_started(ability: AbilitySlot) -> void:
	if not ability.ability.is_single_targeted():
		return
	
	targeting = true
	area_2d.monitoring = true
	area_2d.monitorable = true
	current_ability = ability


func _on_ability_targeting_ended(_ability: AbilitySlot) -> void:
	targeting = false
	ability_arc.clear_points()
	area_2d.position = Vector2.ZERO
	area_2d.monitoring = false
	area_2d.monitorable = false
	current_ability = null


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not current_ability or not targeting:
		return
	
	if not current_ability.targets.has(area):
		current_ability.targets.append(area)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if not current_ability or not targeting:
		return
	
	current_ability.targets.erase(area)
