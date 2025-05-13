extends CanvasLayer

@onready var spellbook_view: AbilityMenuView = %SpellbookView


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spellbook_button"):
		spellbook_view
		if spellbook_view.ability_list != null:
			spellbook_view.visible = !spellbook_view.visible
			
