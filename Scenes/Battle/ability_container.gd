class_name AbilityContainer
extends GridContainer


func _ready() -> void:
	for child in get_children():
		var ability_slot := child as AbilitySlot
		ability_slot.parent = self
		ability_slot.reparent_requested.connect(_on_ability_ui_reparent_requested)


func _on_ability_ui_reparent_requested(ability: AbilitySlot) -> void:
	ability.reparent(self)
