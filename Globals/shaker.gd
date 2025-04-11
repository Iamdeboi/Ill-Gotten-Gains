extends Node


func shake(object: Node2D, shake_strength: float, duration: float = 0.2) -> void:
	if not object:
		return
	
	var original_pos := object.position
	var shake_count := 10
	var tween := create_tween()
	
	for i in shake_count:
		var shake_offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		var target := original_pos + shake_strength * shake_offset
		if i % 2 == 0:
			target = original_pos
		tween.tween_property(object, "position", target, duration / float(shake_count))
		shake_strength *= 0.75 #Eases shakes by 25% each time
	
	object.position = original_pos


func control_node_shake(object: Control, shake_strength: float, duration: float = 0.2) -> void:
	if not object:
		return
	
	var original_pos := object.position
	var shake_count := 10
	var tween := create_tween()
	
	for i in shake_count:
		var shake_offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		var target := original_pos + shake_strength * shake_offset
		if i % 2 == 0:
			target = original_pos
		tween.tween_property(object, "position", target, duration / float(shake_count))
		shake_strength *= 0.75 #Eases shakes by 25% each time
	
	await tween.finished
	object.position = original_pos
