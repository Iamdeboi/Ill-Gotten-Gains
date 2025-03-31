class_name AbilityContainer
extends GridContainer

var abilities_played_this_turn := 0

func _ready() -> void:
	EventBus.ability_used.connect(_on_ability_used)
	
	for child in get_children():
		var ability_slot := child as AbilitySlot
		ability_slot.parent = self
		ability_slot.reparent_requested.connect(_on_ability_ui_reparent_requested)


func _on_ability_used(_ability: Ability) -> void:
	abilities_played_this_turn += 1

func _on_ability_ui_reparent_requested(child: AbilitySlot) -> void:
	child.disabled = true
	child.reparent(self)
	var new_index := clampi(child.original_index - abilities_played_this_turn, 0, get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)
